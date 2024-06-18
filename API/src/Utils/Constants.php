<?php

namespace DavidsBookClub\Utils;

/**
 * Gets values from the .env file, in a clean and easy to understand manner.
 */
class Constants
{
    /**
     * Gets all required database information, to create a connection to the database.
     * @return array<string,string> An associative array, which has the following keys: "DB_HOST", "DB_USER", "DB_PASS", DB_NAME"
     */
    public static function getDatabaseInfo()
    {
        return array(
            "DB_HOST" => $_ENV['DB_HOST'], // Hostname
            "DB_USER" => $_ENV['DB_USER'], // Username
            "DB_PASS" => $_ENV['DB_PASS'], // Password associated with the username
            "DB_NAME" => $_ENV['DB_NAME'], // Name of the database
        );
    }

    /**
     * Gets the allowed origins to access the API.
     * @return array<string> String array which holds each of the origins allowed.
     */
    public static function getAllowedOrigins()
    {
        $rawOrigins = $_ENV['ALLOWED_HOSTS'];
        return array_map('trim', explode(",", $rawOrigins));
    }

    /**
     * Gets the public routes for the API. Public routes do not require authentication.
     * @return array<string> String array which holds each of the public routes.
     */
    public static function getPublicRoutes()
    {
        $rawRoutes = $_ENV['PUBLIC_ROUTES'];
        return array_map('trim', explode(",", $rawRoutes));
    }

    /**
     * Gets the KID (Key identification), used for JWT encoding.
     * @return string The KID value.
     */
    public static function getKid()
    {
        return $_ENV["KID"];
    }

    /**
     * Gets the pepper, used for password hashing.
     * @return string The pepper value.
     */
    public static function getPepper()
    {
        return $_ENV["PEPPER"];
    }

    /**
     * Gets the encryption key, used for encrypting various kinds of data.
     * @return string The encryption key value.
     */
    public static function getEncryptionKey()
    {
        return $_ENV["ENCRYPTION_KEY"];
    }

    /**
     * Gets the JWT secret key, used for encoding and decoding Json Web Tokens.
     * @return string The JWT secret key.
     */
    public static function getJwtSecretKey()
    {
        return $_ENV["SECRET_KEY"];
    }
}
