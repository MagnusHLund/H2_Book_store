<?php

namespace DavidsBookClub\Controllers;

use DavidsBookClub\Utils\Database;
use DavidsBookClub\Utils\MessageManager;
use DavidsBookClub\Utils\SecurityManager;

class UsersController
{
    private $securityManager;

    public function __construct()
    {
        $this->securityManager = new SecurityManager();
    }

    /**
     * This function gets user billing information.
     * To identify the user, a JWT is used to get the userId
     */
    public function getUserBillingInfo()
    {
        // Call SP with the UserId as a parameter. Return stored user billing information.

        $billingInfo = "";

        $decryptedEmail = $this->securityManager->decryptData($billingInfo->email);
        $decryptedPhoneNumber = $this->securityManager->decryptData($billingInfo->phoneNumber);

        $decryptedInfo = "";

        MessageManager::sendSuccess($decryptedInfo);
    }

    /**
     * This function creates a user in the database.
     * @param object $payload This parameter holds all the data required to create a user.
     *              `$payload->name`
     *              `$payload->email`
     *              `$payload->password`
     *              `$payload->verifyPassword`
     *              `$payload->houseNumber`
     *              `$payload->zipCode`
     *              `$payload->streetName`
     *              `$payload->phoneNumber`
     */
    public function createUser($payload)
    {
        if (
            isset(
                $payload['name'],
                $payload['email'],
                $payload['password'],
                $payload['verifyPassword'],
                $payload['houseNumber'],
                $payload['zipCode'],
                $payload['streetName'],
                $payload['phoneNumber']
            )
        ) {
            // Call stored procedure to verify that the email does not already exist.
            //$uniqueEmail = Database::callStoredProcedure("CheckEmailUnique", array("userEmail" => $payload['email'], "PDO::PARAM_STR"));
            $uniqueEmail = Database::testSP();

            if ($uniqueEmail) {
                // If email exists
                MessageManager::sendError("Email is already in use", 409);
                exit;
            }

            if ($payload->password != $payload->verifyPassword) {
                MessageManager::sendError("Passwords do not match", 401);
                exit;
            }

            if (!$this->securityManager->verifyNewPassword($payload->password)) {
                MessageManager::sendError("Password does not follow requirements", 401);
                exit;
            }

            $salt = $this->securityManager->generateSalt();
            $hashedPassword = $this->securityManager->hashPassword($payload->password, $salt);

            $encryptedEmail = $this->securityManager->encryptData($payload->email);
            $phoneNumber = $this->securityManager->encryptData($payload->phoneNumber);

            // Stored procedure to create the user. Return userId.

            $jwt = $this->securityManager->encodeJwt($response->userId);

            $oneDay = 86400;
            setcookie("jwt", $jwt,  time() + $oneDay, "/", null, null, true);
        } else {
            MessageManager::missingParameters();
        }
    }

    /**
     * This function is used to login a user.
     * @param object $payload `$payload->email` and `$payload->password` is used to login the user.
     */
    public function loginUser($payload)
    {
        if (isset($payload->email, $payload->password)) {
            // Call SP to receive userId, password and salt, from the user.

            $response = "";
            if (empty($response)) {
                MessageManager::sendError("Invalid credentials", 403);
                exit;
            }

            if (!$this->securityManager->verifyHashedPassword($payload->password, $response->password, $response->salt)) {
                MessageManager::sendError("Invalid credentials", 403);
                exit;
            }

            $jwt = $this->securityManager->encodeJwt($response->userId);

            $oneDay = 86400;
            setcookie("jwt", $jwt,  time() + $oneDay, "/", null, null, true);
        }
    }

    /**
     * This function removes the cookie, holding the JWT.
     * It sets the expiration to an hour ago, which is common practice for removing a cookie.
     */
    public function logoutUser()
    {
        $oneHour = 3600;
        setcookie("jwt", "",  time() - $oneHour, "/", null, null, true);
    }

    public function verifyLoggedIn()
    {
        if (isset($_COOKIE['jwt'])) {
            $jwt = $_COOKIE['jwt'];
            // Decode and verify the JWT
            $decodedJwt = $this->securityManager->decodeJwt($jwt);
            if ($decodedJwt) {
                MessageManager::sendSuccess("You are logged in!");
            }
        }

        MessageManager::sendError("You are not logged in", 401);
    }
}
