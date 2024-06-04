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
        } catch (PDOException $exception) {
            http_response_code(500);
            echo json_encode(["error" => "Database procedure error " . $exception->getMessage()]);
        }
    }

    private static function connectToDatabase()
    {
        try {
            $databaseInfo = Constants::getDatabaseInfo();

            $host = $databaseInfo['DB_HOST'];
            $user = $databaseInfo['DB_USER'];
            $password = $databaseInfo['DB_PASS'];
            $database = $databaseInfo['DB_NAME'];

            $conn = new PDO("mysql:host=$host;dbname=$database", $user, $password);
            $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $exception) {
            http_response_code(500);
            echo json_encode(["error" => "Database connection error " . $exception->getMessage()]);
            exit;
        }
    }
}
