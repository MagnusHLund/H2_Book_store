<?php

namespace MichaelsBookClub\Utils;

use PDO;
use PDOException;

class Database
{
    private static $pdo;

    // init() is used as a form of constructor, but constructors are not used by static functions
    public static function init()
    {
        // Assigns databaseInfo database connection information via the getDatabaseInfo method
        $DatabaseInfo = Constants::getDatabaseInfo();

        // Here the Database Source Name is reciving data from $DatabaseInfo for the DSN string
        $dsn = "mysql:host=" . $DatabaseInfo['DB_HOST'] . ";dbname=" . $DatabaseInfo['DB_NAME'];
        // Extracts user and password from the databaseInfo
        $dbusername= $DatabaseInfo['DB_USER'];
        $dbpassword= $DatabaseInfo['DB_PASS'];

        try {
            // Create a PDO connection using the DSN, username, and password
            self::$pdo = new PDO($dsn, $dbusername, $dbpassword);
        
            // Set PDO error mode to throw exceptions for easier error handling
            self::$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        } catch (PDOException $e) {
            // Catch any PDO exceptions that occur during connection establishment
            
            // Echo an error message indicating connection failure along with the error message
            echo "Connection failed: " . $e->getMessage();
        }
        
    }

    public static function create($procedureName, $data)
    {
        try {
            // Prepare the SQL statement with placeholders for parameters
            $statement = self::$pdo->prepare("CALL $procedureName(:data)");

            // Helps to prevent sql injections by binding the PHP variable $data to the sql statement :data
            $statement->bindParam(':data', $data);
    
            $statement->execute();
            // Catches all exceptions and showing them to the user
        } catch (PDOException $e) {
            // Handle the exception if the execution fails
            echo "Error executing stored procedure: " . $e->getMessage();
        }
    }
    
}

Database::init();
