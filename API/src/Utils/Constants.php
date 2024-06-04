<?php

namespace DavidsBookClub\Utils;

class Constants
{
    public static function getDatabaseInfo()
    {
        return array(
            "DB_HOST" => $_ENV['DB_HOST'],
            "DB_USER" => $_ENV['DB_USER'],
            "DB_PASS" => $_ENV['DB_PASS'],
            "DB_NAME" => $_ENV['DB_NAME'],
        );
    }

    public static function getAllowedOrigins()
    {
        $rawOrigins = $_ENV['ALLOWED_HOSTS'];
        return array_map('trim', explode(",", $rawOrigins));
    }

    public static function getPublicRoutes()
    {
        $rawRoutes = $_ENV['PUBLIC_ROUTES'];
        return array_map('trim', explode(",", $rawRoutes));
    }

    public static function getKid()
    {
        return $_ENV["KID"];
    }

    public static function getPepper()
    {
        return $_ENV["PEPPER"];
    }

    public static function getEncryptionKey()
    {
        return $_ENV["ENCRYPTION_KEY"];
    }

    public static function getJwtSecretKey()
    {
        return $_ENV["SECRET_KEY"];
    }
}
