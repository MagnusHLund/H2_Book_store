<?php

namespace DavidsBookClub\Utils;

use PDO;
use PDOException;
use DavidsBookClub\Utils\Constants;

class Database
{
    public static function callStoredProcedure($procedureName, $params)
    {
        try {
            self::connectToDatabase();
        } catch (PDOException $e) {
            MessageManager::sendError("Database procedure error", 500, "Encountered an error in relation to calling a stored procedure: " . $e->getMessage());
        }
    }

    private static function connectToDatabase()
    {
        try {
            $databaseInfo = Constants::getDatabaseInfo();

            $hostname = $databaseInfo['DB_HOST'];
            $username = $databaseInfo['DB_USER'];
            $password = $databaseInfo['DB_PASS'];
            $database = $databaseInfo['DB_NAME'];

            $conn = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            MessageManager::sendError("Database connection error", 500, "Error connecting to the database" . $e->getMessage());
            exit;
        }
    }
}
