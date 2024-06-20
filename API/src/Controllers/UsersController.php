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

        $billingInfo = Database::callStoredProcedure("");

        $decryptedEmail = $this->securityManager->decryptData($billingInfo['email']);
        $decryptedPhoneNumber = $this->securityManager->decryptData($billingInfo['phoneNumber']);

        $decryptedInfo = "";

        MessageManager::sendSuccess($decryptedInfo);
    }

    /**
     * This function creates a user in the database.
     * @param array $payload This parameter holds all the data required to create a user.
     *              `$payload['name']`
     *              `$payload['email']`
     *              `$payload['password']`
     *              `$payload['verifyPassword']`
     *              `$payload['houseNumber']`
     *              `$payload['zipCode']`
     *              `$payload['streetName']`
     *              `$payload['phoneNumber']`
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
            $encryptedEmail = $this->securityManager->encryptData($payload['email']);
            $uniqueEmail = Database::callStoredProcedure("CheckEmailUnique", ["userEmail" => $encryptedEmail]);
            $uniqueEmail = array_values($uniqueEmail[0]);

            if ($uniqueEmail[0] != 0) {
                // If email exists
                MessageManager::sendError("Email is already in use", 409);
                exit;
            }

            if ($payload['password'] != $payload['verifyPassword']) {
                MessageManager::sendError("Passwords do not match", 401);
                exit;
            }

            if (!$this->securityManager->verifyNewPassword($payload['password'])) {
                MessageManager::sendError("Password does not follow requirements", 401);
                exit;
            }

            $salt = $this->securityManager->generateSalt();
            $hashedPassword = $this->securityManager->hashPassword($payload['password'], $salt);

            $encryptedPhoneNumber = $this->securityManager->encryptData($payload['phoneNumber']);

            // Stored procedure to create the user. Return userId.
            $userId = Database::callStoredProcedure(
                "CreateUser",
                [
                    "userName" => $payload['name'],
                    "userEmail" => $encryptedEmail,
                    "userPhoneNumber" => $encryptedPhoneNumber,
                    "userPassword" => $hashedPassword,
                    "userSalt" => $salt,
                    "userRole" => "User",
                    "userAddressId" => 1
                ]
            );

            $userId = $userId[0]['user_id'];

            if (empty($userId)) {
                MessageManager::sendError(
                    "Error creating user in the database",
                    500,
                    "Newly created user was not created in the database"
                );
            }

            $jwt = $this->securityManager->encodeJwt($userId);

            $oneDay = 86400;
            setcookie("jwt", $jwt,  time() + $oneDay, "/", null, null, true);
            MessageManager::sendSuccess("Account created!");
        } else {
            MessageManager::missingParameters();
        }
    }

    /**
     * This function is used to login a user.
     * @param array $payload `$payload['email']` and `$payload['password']` is used to login the user.
     */
    public function loginUser($payload)
    {
        if (isset($payload['email'], $payload['password'])) {
            // Call SP to receive userId, password and salt, from the user
            $response = "";
            if (empty($response)) {
                MessageManager::sendError("Invalid credentials", 403);
                exit;
            }

            if (!$this->securityManager->verifyHashedPassword($payload['password'], $response['password'], $response['salt'])) {
                MessageManager::sendError("Invalid credentials", 403);
                exit;
            }

            $jwt = $this->securityManager->encodeJwt($response['userId']);

            $oneDay = 86400;
            setcookie("jwt", $jwt,  time() + $oneDay, "/", null, null, true);
        } else {
            MessageManager::missingParameters();
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
