<?php

namespace DavidsBookClub\Controllers;

use DavidsBookClub\Utils\Database;
use DavidsBookClub\Utils\MessageManager;
use DavidsBookClub\Utils\SecurityManager;
use DavidsBookClub\Enums\StoredProcedures;

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
        $jwt = securityManager::decodeJwt($_COOKIE['jwt']);
        $billingInfo = Database::callStoredProcedure(StoredProcedures::GetUserInformation, ["user_id_param" => $jwt]);

        $billingInfo = $billingInfo[0];

        $decryptedEmail = $this->securityManager->decryptData($billingInfo['email'], false);
        $decryptedPhoneNumber = $this->securityManager->decryptData($billingInfo['phoneNumber'], false);
        $decryptedName = $this->securityManager->decryptData($billingInfo['username']);
        $decryptedStreetName = $this->securityManager->decryptData($billingInfo['streetName']);
        $decryptedHouseNumber = $this->securityManager->decryptData($billingInfo['houseNumber']);

        $decryptedInfo = ["email" => $decryptedEmail, "phoneNumber" => $decryptedPhoneNumber, "name" => $decryptedName, "streetName" => $decryptedStreetName, "houseNumber" => $decryptedHouseNumber];

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
            $encryptedEmail = $this->securityManager->encryptData($payload['email'], false);
            $uniqueEmail = Database::callStoredProcedure(StoredProcedures::CheckEmailUnique->name, ["userEmail" => $encryptedEmail]);
            $uniqueEmail = array_values($uniqueEmail[0]);

            if ($uniqueEmail[0] != 0) {
                // If email exists
                MessageManager::sendError("Email is already in use", 409);
                exit;
            }

            $encryptedPhoneNumber = $this->securityManager->encryptData($payload['phoneNumber'], false);
            $uniquePhone = Database::callStoredProcedure(StoredProcedures::CheckUserPhoneExists->name, ["userPhoneNumber" => $encryptedPhoneNumber]);
            $uniquePhone = array_values($uniquePhone[0]);

            if ($uniquePhone[0] != 0) {
                MessageManager::sendError("Phone number is already in use", 409);
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

            $encryptedName = $this->securityManager->encryptData($payload['name']);
            $encryptedSteetName = $this->securityManager->encryptData($payload['streetName']);
            $encryptedHouseNumber = $this->securityManager->encryptData($payload['houseNumber']);

            $addressId = Database::callStoredProcedure(StoredProcedures::InsertAddress, [
                "zipCode" => $payload['zipCode'],
                "streetName" => $encryptedSteetName,
                "houseNumber" => $encryptedHouseNumber
            ]);

            // Stored procedure to create the user. Return userId.
            $userId = Database::callStoredProcedure(
                StoredProcedures::CreateUser->name,
                [
                    "userName" => $encryptedName,
                    "userEmail" => $encryptedEmail,
                    "userPhoneNumber" => $encryptedPhoneNumber,
                    "userPassword" => $hashedPassword,
                    "userSalt" => $salt,
                    "userRole" => "User",
                    "userAddressId" => $addressId
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
            $genericError = "Invalid credentials";

            $hashedEmail = $this->securityManager->encryptData($payload['email'], false);

            // Check if the email exists
            $emailExists = Database::callStoredProcedure(StoredProcedures::CheckEmailUnique->name, ["userEmail" => $hashedEmail]);
            $emailExists = array_values($emailExists[0]);

            if ($emailExists[0] == 0) {
                MessageManager::sendError($genericError, 403);
            }

            // Call SP to receive userId, password and salt, from the user
            $storedProcedureResponse = Database::callStoredProcedure(StoredProcedures::GetUserCredentials->name, ["userEmail" => $payload['email']]);
            if (empty($storedProcedureResponse)) {
                MessageManager::sendError($genericError, 403);
            }

            if (!$this->securityManager->verifyHashedPassword($payload['password'], $storedProcedureResponse['password'], $storedProcedureResponse['salt'])) {
                MessageManager::sendError($genericError, 403);
            }

            $jwt = $this->securityManager->encodeJwt($storedProcedureResponse['userId']);

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
        try {
            if (isset($_COOKIE['jwt'])) {
                $jwt = $_COOKIE['jwt'];
                // Decode and verify the JWT
                $decodedJwt = $this->securityManager->decodeJwt($jwt);
                if ($decodedJwt) {
                    MessageManager::sendSuccess("You are logged in!");
                    exit;
                }
            }
        } finally {
            MessageManager::sendError("You are not logged in", 401);
        }
    }
}
