<?php
namespace CMS\Auth;

require_once("DBController.php");
class Auth {
    function getMemberByRegId($reg_id)
    {
        $db_handle = new \CMS\DBController\DBController();
        $query = "SELECT R.RegistrantID, R.NameFirst, R.NameLast, R.Email, R.Password FROM Registrants R WHERE R.Status='Submitted' AND R.TestRecord=0 AND R.RegistrantID=:rid;";
        $result = $db_handle->runQuery($query, ['rid'], [$reg_id]);
        return $result;
    }
    
    function getMemberByEmail($email)
    {
        $db_handle = new \CMS\DBController\DBController();
        $email = trim($email);
        $query = "SELECT R.RegistrantID, R.NameFirst, R.NameLast, R.Email, R.Password FROM Registrants R WHERE R.Status='Submitted' AND R.TestRecord=0 AND R.Email=:em;";
        $result = $db_handle->runQuery($query, ['em'], [$email]);
        return $result;
    }
    
    function getMemberMaskByRegId($reg_id)
    {
      $db_handle = new \CMS\DBController\DBController();
      $query = "SELECT RR.AccessMask FROM Registrants R INNER JOIN RegItems I ON (R.RegistrantID=I.RegistrantID AND I.Deleted=0 AND I.Refund=0) INNER JOIN RegRates RR ON (I.RegItemID=RR.RegItemID) WHERE R.Status='Submitted' AND R.TestRecord=0 AND R.RegistrantID=:rid;";
      $result = $db_handle->runQuery($query, ['rid'], [$reg_id]);
      $userMask = 0;
      
      // ob_start();
      // var_dump($result);
      // error_log(ob_get_clean());

      if (is_array($result))
      {
        foreach ($result as $row)
        {
          // echo "\n#" . $row['AccessMask'] . "|" . $row['Received'] . "#\n";
          // echo "\n!" . ($row['Received'] ? $row['AccessMask'] : 0) . "!\n";
          $userMask |= $row['AccessMask'];
          // echo "\n@" . $userMask . "@\n";
        }
      }
      return $userMask;
    }

    function checkAccessMask($userMask, $accessMask)
    {
        return ($userMask & $accessMask) > 0;
    }
    
    function checkAccessMaskByItem($userMask, $accessMask, $reg_id, $item_type, $item_id)
    {
        $db_handle = new \CMS\DBController\DBController();

        // Types
        /*
            0: Reserved
            1: Tutorial
            2: Reg Item
        */
        if (($userMask & $accessMask) > 0)
        {
            switch ($item_type)
            {
                case 1:
                    $q = "SELECT COUNT(*) AS TheCount FROM RegItems I INNER JOIN Registrants R ON (R.RegistrantID=I.RegistrantID AND R.Status='Submitted' AND R.TestRecord=0 AND I.Deleted=0 AND I.Refund=0 AND I.Quantity>0) INNER JOIN RegRates RR ON (I.RegItemID=RR.RegItemID) INNER JOIN Tutorials T ON (RR.CrossRefID=T.TutorialID) WHERE R.RegistrantID=:rid AND T.TutorialID=:tid;";
                    $result = $db_handle->RunQuery($q, ['rid','tid'], [$reg_id, $item_id]);
                    if ($result)
                    {
                        return ($result[0]['TheCount']>0);
                    }
                    else
                    {
                        return false;
                    }
                break;

                case 2:
                    $q = "SELECT COUNT(*) AS TheCount FROM RegItems I INNER JOIN Registrants R ON (R.RegistrantID=I.RegistrantID AND R.Status='Submitted' AND R.TestRecord=0 AND I.Deleted=0 AND I.Refund=0 AND I.Quantity>0) INNER JOIN RegRates RR ON (I.RegItemID=RR.RegItemID) INNER JOIN Meetings M ON (RR.QtyAvailableID=M.CrossRef) WHERE R.RegistrantID=:rid AND M.MeetingID=:meeting_id;";
                    $result = $db_handle->RunQuery($q, ['rid','meeting_id'], [$reg_id, $item_id]);
                    if ($result)
                    {
                        return ($result[0]['TheCount']>0);
                    }
                    else
                    {
                        return false;
                    }
                break;

                default:
                    return false;
                break;
            }
        }
        else
        {
            return false;
        }
    }
    
    function getTokenByRegId($reg_id,$expired)
    {
      $db_handle = new \CMS\DBController\DBController();
      $query = "Select * from token_auth where reg_id = :rid and is_expired = :exp";
      $result = $db_handle->runQuery($query, ['rid','exp'], [$reg_id, $expired]);
      return $result;
    }
    
    function markAsExpired($tokenId)
    {
        $db_handle = new \CMS\DBController\DBController();
        $query = "UPDATE token_auth SET is_expired = :exp WHERE id = :tid";
        $expired = 1;
        $result = $db_handle->update($query, ['exp','tid'], [$expired, $tokenId]);
        return $result;
    }
    
    function insertToken($username, $random_password_hash, $random_selector_hash, $expiry_date)
    {
        $db_handle = new \CMS\DBController\DBController();
        $query = "INSERT INTO token_auth (reg_id, password_hash, selector_hash, expiry_date) values (:rid, :pwhash, :selhash, :expdate)";
        $result = $db_handle->insert($query, ['rid','pwhash','selhash','expdate'], [$username, $random_password_hash, $random_selector_hash, $expiry_date]);
        return $result;
    }

    function validateVirtualAccess($_regId, $_sid, $_pid, $_start, $_end)
    {
        $virtualGranted = false;
        $virtualMessage = null;
        $virtualPrivileged = false;

        // error_log($this->getMemberMaskByRegId($_regId));

        // error_log("Verifying access by {$_regId} for Session {$_sid}");
        // Check virtualGranted
        if ($_regId)
        {
            // $db_handle = new CMS\DBController\DBController();
            // First check Admin/Super
            if ($this->checkAccessMask($this->getMemberMaskByRegId($_regId), 12))
            {
                // error_log("Access by {$_regId} for Session {$_sid} by admin/super");
                $virtualGranted = true;
                $virtualPrivileged = true;
            }
            // Second, check if user is a session chair or manager of *this session* 
            elseif ($this->isSessionChairOrManager($_regId, $_sid))
            {
                // error_log("Access by {$_regId} for Session {$_sid} by chair/manager");
                $virtualGranted = true;
                $virtualPrivileged = true;
            }
            // Third, check if user is a presenter of a paper in *this session* or *this paper*
            elseif ($this->isPresenter($_regId, $_pid, $_sid))
            {
                // error_log("Access by {$_regId} for PaperNum {$_pn} by Presenter");
                $virtualGranted = true;
                $virtualPrivileged = true;
            }
            // Fourth, check if user is granted generic privileged access
            elseif ($this->checkAccessMask($this->getMemberMaskByRegId($_regId), 256))
            {
                // error_log("Access by {$_regId} for PaperNum {$_pn} by Presenter");
                $virtualGranted = true;
                $virtualPrivileged = true;
            }
            // Fifth, check if user is granted early access
            elseif ($this->checkAccessMask($this->getMemberMaskByRegId($_regId), 128))
            {
                // error_log("Access by {$_regId} for PaperNum {$_pn} by Presenter");
                $virtualGranted = true;
                // $virtualPrivileged = true;
            }
            // Last, check if dates are within allowed range
            // virtualstart = "2020-09-10 08:00:00"
            // virtualend = "2020-12-01 08:00:00"
            elseif (
                (new \DateTime($_start))->diff(new \DateTime())->invert == 0
                &&
                (new \DateTime($_end))->diff(new \DateTime())->invert == 1
            )
            {
                if ($this->checkAccessMask($this->getMemberMaskByRegId($_regId), 1))
                {
                    // $temp = $this->getMemberMaskByRegId($_regId);
                    // error_log("Access by {$_regId} for Session {$_sid} by item, mask {$temp}");
                    $virtualGranted = true;
                }
                else
                {
                    $virtualGranted = false;
                    $virtualMessage = "Item not included in subscription.";
                }
            }
            else
            {
                $virtualGranted = false;
                $virtualMessage = "Virtual event is not active.";
            }
        }
        else
        {
            $virtualGranted = false;
            $virtualMessage = "Not logged in.";
        }
        // End virtualGranted

        return ['granted'=>$virtualGranted, 'message'=>$virtualMessage, 'privileged'=>$virtualPrivileged];
    }

    function isPresenter($_regId, $_pn=0, $_sid=0)
    {
        // Check virtualGranted
        if ($_regId)
        {
            $db_handle = new \CMS\DBController\DBController();
            $result = $db_handle->runQuery(<<<SQL
                SELECT CASE WHEN EXISTS(
                    SELECT * FROM Registrants R
                    INNER JOIN PapersRegistrants PREG ON (
                        R.TestRecord=0 AND R.Status='Submitted' AND (
                            PREG.RegistrantID=R.RegistrantID AND PREG.Active=1 AND PREG.Presenter=1
                            AND PREG.Submitted=1
                        )
                    )
                    INNER JOIN FinalPapers P ON (PREG.PaperNum=P.PaperNum AND (P.PaperNum=CASE WHEN :pn1=0 THEN P.PaperNum ELSE :pn2 END))
                    INNER JOIN Sessions S ON (P.SessionID=S.SessionID AND (S.SessionID=CASE WHEN :sid1=0 THEN S.SessionID ELSE :sid2 END))
                    WHERE R.RegistrantID=:rid
                )
                THEN 1 ELSE 0 END AS [result];
                SQL
                , ['rid','pn1','pn2','sid1','sid2'], [$_regId, $_pn, $_pn, $_sid, $_sid]);
            if ($result)
            {
                return ($result[0]['result'] == 1);
            }
        }
        else
        {
            return false;
        }
    }


    function isSessionChair($_regId, $_sid=0, $_manager=0)
    {
        // Check virtualGranted
        if ($_regId)
        {
            $m = 0;
            $c = 0;
            if ($_manager==-1)
            {
                $m = 1;
                $c = 0;
            }
            elseif ($_manager==1)
            {
                $m = 1;
                $c = 1;
            }
            else
            {
                $m = 0;
                $c = 0;
            }
            $db_handle = new \CMS\DBController\DBController();
            $result = $db_handle->runQuery("SELECT CASE WHEN EXISTS( SELECT * FROM Registrants R INNER JOIN SessionChairs SC ON ( R.TestRecord=0 AND R.Status='Submitted' AND ((SC.Email LIKE R.Email) OR (R.RegistrantID=SC.RegistrantID))) WHERE R.RegistrantID=:rid AND (SC.SessionID=CASE WHEN :sid1=0 THEN SC.SessionID ELSE :sid2 END) AND (SC.Manager=:mg1 OR SC.Manager=:mg2) ) THEN 1 ELSE 0 END AS [result];", ['rid','mg1', 'mg2', 'sid1', 'sid2'], [$_regId, $m, $c, $_sid, $_sid]);
            if ($result)
            {
                return ($result[0]['result'] == 1);
            }
        }
        else
        {
            return false;
        }
    }

    function isSessionManager($_regId, $_sid=0)
    {
        return $this->isSessionChair($_regId, $_sid, 1);
    }

    function isSessionChairOrManager($_regId, $_sid=0)
    {
        return $this->isSessionChair($_regId, $_sid, -1);
    }

  function logEntry($query, $param_name_array, $param_value_array)
  {
    $db_handle = new \CMS\DBController\DBController();
    $db_handle->insert($query, $param_name_array, $param_value_array);
    return true;
  }
}
?>