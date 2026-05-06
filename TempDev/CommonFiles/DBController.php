<?php
namespace CMS\DBController;

require_once('_config.php');

class DBController
{
  private $conn;
  
  function __construct($readonly = false)
  {
    if ($readonly)
    {
      $this->conn = $this->connectDBRO();
    }
    else
    {
      $this->conn = $this->connectDB();
    }
  }  
  
  function connectDB() {
    // $conn = mysqli_connect($this->host,$this->user,$this->password,$this->database);
    global $config, $db_PDO_options;
    $conn = new \PDO( db_PDO_makeConnString($config['database']['dsnserver'], $config['database']['dsnname']), $config['database']['dsnuser'], $config['database']['dsnpass'], $db_PDO_options);
    return $conn;
  }
  
  function connectDBRO() {
    // $conn = mysqli_connect($this->host,$this->user,$this->password,$this->database);
    global $config, $db_PDO_options;
    $conn = new \PDO( db_PDO_makeConnString($config['database']['dsnserver'], $config['database']['dsnname']), $config['database']['dsnuserro'], $config['database']['dsnpassro'], $db_PDO_options);
    return $conn;
  }
  
  function runBaseQuery($query)
  {
    // $result = mysqli_query($this->conn,$query);
    $result = $this->conn->query($query);
    // while($row=mysqli_fetch_assoc($result))
    while($row = $result->fetch())
    {
      $resultset[] = $row;
    }    
    if (!empty($resultset))
      return $resultset;
  }
    
  function runQuery($query, $param_name_array, $param_value_array)
  {
    $sql = $this->conn->prepare($query, [\PDO::ATTR_CURSOR => \PDO::CURSOR_SCROLL]);
    $this->bindQueryParams($sql, $param_name_array, $param_value_array);
    $sql->execute();

    if ($sql->rowCount() > 0)
    {
      while($row = $sql->fetch())
      {
        $resultset[] = $row;
      }
    }
    
    if(!empty($resultset))
    {
      return $resultset;
    }
  }
    
  function runQuery2($query, $params)
  {
    $sql = $this->conn->prepare($query, [\PDO::ATTR_CURSOR => \PDO::CURSOR_SCROLL]);
    // $this->bindQueryParams($sql, $param_name_array, $param_value_array);
    $sql->execute($params);

    if ($sql->rowCount() > 0)
    {
      while($row = $sql->fetch())
      {
        $resultset[] = $row;
      }
    }
    
    if(!empty($resultset))
    {
      return $resultset;
    }
  }
    
  function bindQueryParams($rst, $param_name_array, $param_value_array)
  {
    // $param_value_reference[] = & $param_type;
    for ($i=0; $i<count($param_value_array); $i++)
    {
      // $param_value_reference[] = & $param_value_array[$i];
      call_user_func_array(
        [$rst, 'bindParam'],
        [
          $param_name_array[$i],
          & $param_value_array[$i]
        ]
      );
    }
  }
  
  function insert($query, $param_name_array, $param_value_array)
  {
    $rst = $this->conn->prepare($query);
    $this->bindQueryParams($rst, $param_name_array, $param_value_array);
    $rst->execute();
  }
  
  function insert2($query, $params)
  {
    $rst = $this->conn->prepare($query);
    $rst->execute($params);
  }
  
  function update($query, $param_name_array, $param_value_array)
  {
    $rst = $this->conn->prepare($query);
    $this->bindQueryParams($rst, $param_name_array, $param_value_array);
    $rst->execute();
  }

  function update2($query, $params)
  {
    $rst = $this->conn->prepare($query);
    $rst->execute($params);
  }
}
?>