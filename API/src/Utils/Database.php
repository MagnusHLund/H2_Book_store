<?php

namespace DavidsBookClub\Utils;

use PDO;
use PDOException;
use DavidsBookClub\Utils\Constants;

class Database
{
    /**
     * Calls a stored procedure in the database.
     * @param string $procedureName The name of the stored procedure, which should be called.
     * @param array $params Holds all the input parameters for the stored procedure.
     */
    public static function callStoredProcedure($procedureName, $params)
    {
        try {
            $conn = self::connectToDatabase();

            // Prepare the SQL statement
            $sql = "CALL $procedureName(";
            $paramBindings = [];

            foreach ($params as $paramName => $paramValue) {
                $sql .= ":$paramName, ";
                $paramBindings[":$paramName"] = $paramValue;
            }

            $sql = rtrim($sql, ', ') . ")";

            $stmt = $conn->prepare($sql);

            // Bind input parameters dynamically
            foreach ($paramBindings as $param => $value) {
                $stmt->bindValue($param, $value);
            }

            // Execute the query
            $stmt->execute();
            $stmt->closeCursor();

            $conn->query($stmt);
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
            return $conn;
        } catch (PDOException $e) {
            MessageManager::sendError("Database connection error", 500, "Error connecting to the database" . $e->getMessage());
            exit;
        }
    }
}
