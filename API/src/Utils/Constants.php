<?php

namespace davidsBookClub\Utils;

class Constants
{
    public static function getDatabaseInfo()
    {
        return array(
            "DB_HOST" => $_ENV['DB_HOST'],
            "DB_USER" => $_ENV['DB_USER'],
            "DB_PASS" => $_ENV['DB_PASSWORD'],
            "DB_NAME" => $_ENV['DB_DATABASE'],
        );
    }

    public static function getAllowedOrigins()
    {
        return $_ENV['ALLOWED_HOSTS'];
    }

    public function getPublicRoutes()
    {
    }

    public function getKid()
    {
    }

    public function getPepper()
    {
    }

    public function getEncryptionKey()
    {
    }
}
