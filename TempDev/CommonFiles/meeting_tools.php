<?php

Class MeetingTools
{
    private $session_api_url;

    public function __construct(&$_config)
    {
        $this->session_api_url = $_config['web']['sessionapiurl'];
    }

    public const EVENT_TIME_FUTURE = 0;
    public const EVENT_TIME_CURRENT = 1;
    public const EVENT_TIME_PAST = 2;

    public const EVENT_TIME_LINK_FUTURE = 3;
    public const EVENT_TIME_LINK_CURRENT = 4;
    public const EVENT_TIME_LINK_PAST = 5;

  /**
  * A sweet interval formatting, will use the two biggest interval parts.
  * On small intervals, you get minutes and seconds.
  * On big intervals, you get months and days.
  * Only the two biggest parts are used.
  *
  * @param DateInterval $start
  * @return string
  */
  public function formatDateDiffInterval($interval)
  {
      $doPlural = function($nb,$str){return $nb>1?$str.'s':$str;}; // adds plurals
    
      $format = array();
      if($interval->y !== 0) {
          $format[] = "%y ".$doPlural($interval->y, "year");
      }
      if($interval->m !== 0) {
          $format[] = "%m ".$doPlural($interval->m, "month");
      }
      if($interval->d !== 0) {
          $format[] = "%d ".$doPlural($interval->d, "day");
      }
      if($interval->h !== 0) {
          $format[] = "%h ".$doPlural($interval->h, "hour");
      }
      if($interval->i !== 0) {
          $format[] = "%i ".$doPlural($interval->i, "minute");
      }
      if($interval->s !== 0) {
          if(!count($format)) {
              return "less than a minute";
          } else {
              $format[] = "%s ".$doPlural($interval->s, "second");
          }
      }
    
      // We use the two biggest parts
      if(count($format) > 1) {
          $format = array_shift($format)." and ".array_shift($format);
      } else {
          $format = array_pop($format);
      }
    
      // Prepend 'since ' or whatever you like
      return $interval->format($format);
  }

  /**
  * A sweet interval formatting, will use the two biggest interval parts.
  * On small intervals, you get minutes and seconds.
  * On big intervals, you get months and days.
  * Only the two biggest parts are used.
  *
  * @param DateInterval $start
  * @return string
  */
  public function formatDateDiffInterval_short($interval)
  {
      $format = array();
      if($interval->y !== 0) {
          $format[] = "%y".'Y';
      }
      if($interval->m !== 0) {
          $format[] = "%m".'M';
      }
      if($interval->d !== 0) {
          $format[] = "%d".'D';
      }
      if($interval->h !== 0) {
          $format[] = "%H".'h';
      }
      if($interval->i !== 0) {
          $format[] = "%I".'m';
      }
      if($interval->s !== 0) {
        $format[] = "%S".'s';
      }
    
      // We use the two biggest parts
      if(count($format) > 1) {
          $format = array_shift($format)." ".array_shift($format);
      } else {
          $format = array_pop($format);
      }
    
      // Prepend 'since ' or whatever you like
      return $interval->format($format);
  }

  /**
  * A sweet interval formatting, will use the two biggest interval parts.
  * On small intervals, you get minutes and seconds.
  * On big intervals, you get months and days.
  * Only the two biggest parts are used.
  *
  * @param DateTime $start
  * @param DateTime|null $end
  * @return string
  */
    public function formatDateDiff($start, $end=null)
    {
        if(!($start instanceof DateTime))
        {
            $start = new DateTime($start);
        }

        if($end === null)
        {
            $end = new DateTime();
        }

        if(!($end instanceof DateTime))
        {
            $end = new DateTime($start);
        }

        $interval = $end->diff($start);
        return $this->formatDateDiffInterval($interval);
    }

    public function event_button_status($event_start, $event_end, $id=null, $advance_interval=null, $extend_interval=null, $options=null)
    {
        $options_default = 
        [
            'current_time'=>null,
        ];

        $options = array_merge($options_default, $options);

        try
        {
            if (!($event_start instanceof DateTimeInterface))
                $event_start = new DateTime($event_start);
        }
        catch (Exception $e)
        {
            error_log('Invalid Date format: '.$e->getMessage());
            $event_start = new DateTime();
        }

        try
        {
            if (!($event_end instanceof DateTimeInterface))
                $event_end = new DateTime($event_end);
        }
        catch (Exception $e)
        {
            error_log('Invalid Date format: '.$e->getMessage());
            $event_end = new DateTime();
        }

        if ($advance_interval===null)
            $advance_interval = new DateInterval('PT0S');
        elseif (!($advance_interval instanceof DateInterval))
            $advance_interval = new DateInterval('PT'.$advance_interval.'S');

        if ($extend_interval===null)
            $extend_interval = $advance_interval;
        elseif (!($extend_interval instanceof DateInterval))
            $extend_interval = new DateInterval('PT'.$extend_interval.'S');

        if ($options['current_time']===null)
            $options['current_time'] = new DateTimeImmutable();

        try
        {
            if (!($options['current_time'] instanceof DateTimeInterface))
            $options['current_time'] = new DateTime($options['current_time']);
        }
        catch (Exception $e)
        {
            error_log('Invalid Date format: '.$e->getMessage());
            $options['current_time'] = new DateTime();
        }

        if ($event_start instanceof DateTimeImmutable)
            $real_start_time = clone $event_start;
        else
            $real_start_time = DateTimeImmutable::createFromMutable($event_start);
        
        if ($event_end instanceof DateTimeImmutable)
            $real_end_time = clone $event_end;
        else
            $real_end_time = DateTimeImmutable::createFromMutable($event_end);


        $link_start_time = $real_start_time->sub($advance_interval);
        $link_end_time = $real_end_time->add($extend_interval);
        $current_time = $options['current_time'];

        // Event Status
        if ($real_end_time < $current_time)
        {
            // Event Ended
            $event_status = self::EVENT_TIME_PAST;
            $time_diff = $real_end_time->diff($current_time);
        }
        elseif ($real_start_time < $current_time)
        {
            // Link Active Time
            $event_status = self::EVENT_TIME_CURRENT;
            $time_diff = $current_time->diff($real_end_time);
        }
        else
        {
            // Pre-Event Time
            $event_status = self::EVENT_TIME_FUTURE;
            $time_diff = $current_time->diff($real_start_time);
        }

        // Link Status
        if ($link_end_time < $current_time)
        {
            // Event Ended
            $link_status = self::EVENT_TIME_LINK_PAST;
            $link_time_diff = $real_end_time->diff($current_time);
        }
        elseif ($link_start_time < $current_time)
        {
            // Link Active Time
            $link_status = self::EVENT_TIME_LINK_CURRENT;
            $link_time_diff = $current_time->diff($link_end_time);
        }
        else
        {
            // Pre-Event Time
            $link_status = self::EVENT_TIME_LINK_FUTURE;
            $link_time_diff = $current_time->diff($link_start_time);
        }

        return [
            'event_status'=>$event_status,
            'link_status'=>$link_status,
            'time_diff'=>$time_diff,
            'link_time_diff'=>$link_time_diff,
        ];
    }

    public function get_link_info($event_start, $event_end, $id=null, $allow_start=false, $advance_interval=null, $extend_interval=null, $options=null)
    {
        $options_default = 
        [
            'current_time'=>null,

            'pre_link_button_text'=>'Live Session begins in {{{time_diff}}}',
            'pre_start_button_text'=>"Join Upcoming Session",
            'active_button_text'=>"Join Session in Progress",
            'ending_button_text'=>"Join Session (Ending soon or ended)",
            'ended_button_text'=>"Live Session Ended",

            'pre_link_manager_button_text'=>'Live Session begins in {{{time_diff}}}',
            'pre_start_manager_button_text'=>"Start Upcoming Zoom Session",
            'active_manager_button_text'=>"Start Zoom Session",
            'ending_manager_button_text'=>"Start Zoom Session",
            'ended_manager_button_text'=>"Live Session Ended",

            'join_url'=>null,
        ];

        if ($options === null)
        {
            $options = [];
        }
        $options = array_merge($options_default, $options);

        // error_log(print_r($options, true));

        if ($id===null)
        {
            $id = ['id'=>null];
        }

        // Set default return structure:
        $return = [
            'event_status'=>null,
            'link_status'=>null,
            'time_diff'=>null,
            'link_time_diff'=>null,
            'live_link'=>null,
            'join_button'=>null,
            'join_badge'=>null,
            'timer_badge'=>null,
            'timer_badge_short'=>null,
            'tag'=>null,
            'id'=>$id,
        ];
        $return = array_merge($return, $this->event_button_status($event_start, $event_end, $id, $advance_interval, $extend_interval, $options));

        /*
            Order of actions:
            MeetingTools::EVENT_TIME_LINK_FUTURE
            MeetingTools::EVENT_TIME_FUTURE
            MeetingTools::EVENT_TIME_LINK_CURRENT
            MeetingTools::EVENT_TIME_CURRENT
            MeetingTools::EVENT_TIME_PAST
            MeetingTools::EVENT_TIME_LINK_PAST
            
            Useful States
            EVENT_TIME_FUTURE && EVENT_TIME_LINK_FUTURE => Before everything
            EVENT_TIME_LINK_CURRENT && EVENT_TIME_FUTURE => Link active, but pre-event
            EVENT_TIME_LINK_CURRENT && EVENT_TIME_CURRENT => In-progress
            EVENT_TIME_LINK_CURRENT && EVENT_TIME_PAST => Event officially over, but can still join
            EVENT_TIME_LINK_PAST && EVENT_TIME_PAST => After everything
        */
        if (
            $return['link_status']==MeetingTools::EVENT_TIME_LINK_PAST &&
            $return['event_status']==MeetingTools::EVENT_TIME_PAST
        )
        {
            // After everything
            if ($allow_start)
            {
                $return['join_button'] = <<<HTML
                    <div style="cursor: default;" disabled class="btn d-block my-2 text-center badge-expiredevent"><strong>{$options['ended_manager_button_text']}</strong></div>
                    HTML;
                $return['join_badge'] = <<<HTML
                    <div class="badge bg-warning d-block my-2 text-center badge-expiredevent"><strong>{$options['ended_manager_button_text']}</strong></div>
                    HTML;
            }
            else
            {               
                $return['join_button'] = <<<HTML
                    <div style="cursor: default;" disabled class="btn d-block my-2 text-center badge-expiredevent"><strong>{$options['ended_button_text']}</strong></div>
                    HTML;
                $return['join_badge'] = <<<HTML
                    <div class="badge bg-warning d-block my-2 text-center badge-expiredevent"><strong>{$options['ended_button_text']}</strong></div>
                    HTML;
            }
            $return['timer_badge'] = <<<HTML
                <div class="badge badge-expiredevent">Event ended {$this->formatDateDiffInterval($return['link_time_diff'])} ago</div>
                HTML;
            $return['timer_badge_short'] = <<<HTML
                <div class="badge badge-expiredevent">Event ended</div>
                HTML;
            $return['tag'] = ["Event ended {$this->formatDateDiffInterval_short($return['link_time_diff'])} ago", 'badge-expiredevent', null, 10];
        }
        elseif (
            $return['link_status']==MeetingTools::EVENT_TIME_LINK_CURRENT &&
            $return['event_status']==MeetingTools::EVENT_TIME_PAST
        )
        {
            // Event officially over, but can still join
            $j = htmlspecialchars(json_encode($id));
            $return['join_button'] = <<<HTML
                <a class="w-100 btn badge-endingevent mt-2" data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['ending_button_text']}');" href="{$options['join_url']}"><i class="bi bi-camera-video-fill"></i> {$options['ending_button_text']}</a>
                HTML;
            $return['join_badge'] = <<<HTML
                <a class="badge badge-endingevent mt-2" data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['ending_button_text']}');" href="{$options['join_url']}"><i class="bi bi-camera-video-fill"></i> {$options['ending_button_text']}</a>
                HTML;
            // Manager!
            if ($allow_start)
            {
                $return['join_button'] = <<<HTML
                    <a class="w-100 btn badge-startevent mt-2" data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['ending_manager_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['ending_manager_button_text']}</a>
                    HTML;
                $return['join_badge'] = <<<HTML
                    <a class="badge badge-startevent mt-2" data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['ending_manager_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['ending_manager_button_text']}</a>
                    HTML;
                $id2 = $id;
                $id2['force_join'] = true;
                $j = htmlspecialchars(json_encode($id2));
                $return['join_button'] .= <<<HTML
                    <a class="w-100 btn badge-activeevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                    HTML;
                $return['join_badge'] .= <<<HTML
                    <a class="badge badge-activeevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                    HTML;
            }
            
        $return['timer_badge'] = <<<HTML
            <div class="badge badge-endingevent">Session link deactivates in {$this->formatDateDiffInterval($return['link_time_diff'])}</div>
            HTML;
        $return['timer_badge_short'] = <<<HTML
            <div class="badge badge-endingevent">Event ending</div>
            HTML;
            $return['tag'] = ["Event ending", 'badge-endingevent', null, 10];
        }
        elseif (
            $return['link_status']==MeetingTools::EVENT_TIME_LINK_CURRENT &&
            $return['event_status']==MeetingTools::EVENT_TIME_CURRENT
        )
        {
            // In-progress
            $j = htmlspecialchars(json_encode($id));
            $return['join_button'] = <<<HTML
                <a class="w-100 btn badge-activeevent"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href="{$options['join_url']}"><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                HTML;
            $return['join_badge'] = <<<HTML
                <a class="badge badge-activeevent"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href="{$options['join_url']}"><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                HTML;
            // Manager!
            if ($allow_start)
            {
                $return['join_button'] = <<<HTML
                    <a class="w-100 btn badge-startevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_manager_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_manager_button_text']}</a>
                    HTML;
                $return['join_badge'] = <<<HTML
                    <a class="badge badge-startevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_manager_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_manager_button_text']}</a>
                    HTML;
                $id2 = $id;
                $id2['force_join'] = true;
                $j = htmlspecialchars(json_encode($id2));
                $return['join_button'] .= <<<HTML
                    <a class="w-100 btn badge-activeevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                    HTML;
                $return['join_badge'] .= <<<HTML
                    <a class="badge badge-activeevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                    HTML;
            }
            
            $return['timer_badge'] = <<<HTML
                <div class="badge badge-activeevent">Event ends in {$this->formatDateDiffInterval($return['time_diff'])}</div>
                HTML;
            $return['timer_badge_short'] = <<<HTML
                <div class="badge badge-activeevent"><i class="bi bi-camera-video-fill"></i> Event in progress</div>
                HTML;
            $return['tag'] = ["Event ends in {$this->formatDateDiffInterval_short($return['time_diff'])}", 'badge-activeevent', null, 10];
        }
        elseif (
            $return['link_status']==MeetingTools::EVENT_TIME_LINK_CURRENT &&
            $return['event_status']==MeetingTools::EVENT_TIME_FUTURE
        )
        {
            // Link active, but pre-event
            $j = htmlspecialchars(json_encode($id));
            $return['join_button'] = <<<HTML
                <a class="w-100 btn badge-startingevent" data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['pre_start_button_text']}');"  href="{$options['join_url']}"><i class="bi bi-camera-video-fill"></i> {$options['pre_start_button_text']}</a>
                HTML;
            $return['join_badge'] = <<<HTML
                <a class="badge badge-startingevent" data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['pre_start_button_text']}');"  href="{$options['join_url']}"><i class="bi bi-camera-video-fill"></i> {$options['pre_start_button_text']}</a>
                HTML;
            // Manager!
            if ($allow_start)
            {
                $return['join_button'] = <<<HTML
                    <a class="w-100 btn badge-startevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['pre_start_manager_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['pre_start_manager_button_text']}</a>
                    HTML;
                $return['join_badge'] = <<<HTML
                    <a class="badge badge-startevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['pre_start_manager_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['pre_start_manager_button_text']}</a>
                    HTML;
                $id2 = $id;
                $id2['force_join'] = true;
                $j = htmlspecialchars(json_encode($id2));
                $return['join_button'] .= <<<HTML
                    <a class="w-100 btn badge-activeevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                    HTML;
                $return['join_badge'] .= <<<HTML
                    <a class="badge badge-activeevent mt-2"  data-cms-api-url="{$this->session_api_url}" data-cms-api-id='{$j}' onclick="return getLiveLink(this, '<i class=\\x22bi bi-camera-video-fill\\x22></i> {$options['active_button_text']}');" href=""><i class="bi bi-camera-video-fill"></i> {$options['active_button_text']}</a>
                    HTML;
            }
            
        $return['timer_badge'] = <<<HTML
            <div class="badge badge-startingevent">Event begins in {$this->formatDateDiffInterval($return['time_diff'])}</div>
            HTML;
        $return['timer_badge_short'] = <<<HTML
            <div class="badge badge-startingevent">Upcoming event</div>
            HTML;
            $return['tag'] = ["Event begins in {$this->formatDateDiffInterval_short($return['time_diff'])}", 'badge-startingevent', null, 10];
        }
        else
        {
            // Before everything
            if ($allow_start)
            {
                $button_text = str_replace('{{{time_diff}}}', $this->formatDateDiffInterval($return['time_diff']), $options['pre_link_manager_button_text']);
            }
            else
            {
                $button_text = str_replace('{{{time_diff}}}', $this->formatDateDiffInterval($return['time_diff']), $options['pre_link_button_text']);
            }
            $return['join_button'] = <<<HTML
                <a class="w-100 btn badge-pendingevent" style="cursor: default;" disabled><strong>{$button_text}</strong></a>
                HTML;
            $return['join_badge'] = <<<HTML
                <a class="w-100 badge badge-pendingevent" style="cursor: default;" disabled><strong>{$button_text}</strong></a>
                HTML;
            $return['timer_badge'] = <<<HTML
                <div class="badge badge-pendingevent">Session link activates in {$this->formatDateDiffInterval($return['link_time_diff'])}</div>
                HTML;
            $return['timer_badge_short'] = <<<HTML
                <div class="badge badge-pendingevent">Upcoming event</div>
                HTML;
            $return['tag'] = ["Event begins in {$this->formatDateDiffInterval_short($return['time_diff'])}", 'badge-pendingevent', null, 10];
        }

        $return['live_link'] = $return['join_button'] . $return['timer_badge'];

        return $return;
    }
}

?>