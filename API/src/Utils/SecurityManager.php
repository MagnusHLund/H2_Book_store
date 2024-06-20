<?php

namespace DavidsBookClub\Utils;

use DavidsBookClub\Utils\Constants;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Exception;

class SecurityManager
{
    const ENCRYPTION_CIPHER = 'AES-128-CBC';
    const JWT_HASHING_ALGORITHM = 'HS256';
    const PASSWORD_HASHING_ALGORITHM = PASSWORD_ARGON2ID;

    // It is bad practice to provide specific errors to the frontend, when dealing with security (such as login). Therefore this generic error message exists.
    const GENERIC_ERROR_MESSAGE = "an error occurred, please try again later!";

    private $encryptionKey;
    private $pepper;

    public function __construct()
    {
        $this->encryptionKey = Constants::getEncryptionKey();
        $this->pepper = Constants::getPepper();
    }

    /**
     * This function is responsible for hashing passwords, using the Argon2id algorithm.
     * @param string $passwordToHash The password which has to be hashed.
     * @param string $salt The salt which should be used to hash the password.
     * @return string The hashed value of $passwordToHash
     */
    public function hashPassword($passwordToHash, $salt)
    {
        try {
            $options = ['memory_cost' => 1024, 'time_cost' => 2, 'threads' => 2];
            return password_hash($passwordToHash . $salt . $this->pepper, self::PASSWORD_HASHING_ALGORITHM, $options);
        } catch (Exception $e) {
            MessageManager::sendError(self::GENERIC_ERROR_MESSAGE, 500, "Unable to hash password: " . $e->getMessage());
        }
    }

    /**
     * This function verifies the input password with a hashed password.
     * @param string $password The password to verify against the hashed password
     * @param string $hashedPassword The hashed password stored in the database
     * @param string $salt The salt used to generate the hashed password
     * @return bool If the $password matches the $hashedPassword, then it returns true, else false.
     */
    public function verifyHashedPassword($password, $hashedPassword, $salt): bool
    {
        try {
            return password_verify($password . $salt . $this->pepper, $hashedPassword);
        } catch (Exception $e) {
            MessageManager::sendError(self::GENERIC_ERROR_MESSAGE, 500, "Error validating password: " . $e->getMessage());
            return false;
        }
    }

    /**
     * This function adds a layer of security, by checking that the password follows the rules.
     * @param string $password The password which has to be verified
     */
    public function verifyNewPassword($password): bool
    {
        $minimumLength = 6;
        $minimumNumbers = 2;
        $requiredMixedCase = true;

        // Check if the length is above the minimum length.
        if (strlen($password) < $minimumLength) {
            return false;
        }

        // Check if password has the minimally required numbers.
        if (!preg_match('/(.*\d.*){' . $minimumNumbers . ',}/', $password)) {
            return false;
        }

        // Check for mixed case letters
        if ($requiredMixedCase && !preg_match('/(?=.*[a-z])(?=.*[A-Z])/', $password)) {
            return false;
        }

        return true;
    }


    /**
     * Generates a string of hexadecimal characters.
     * @return string A randomly generated string of characters.
     */
    public function generateSalt()
    {
        $randomBytes = random_bytes(32);
        return bin2hex($randomBytes);
    }

    /**
     * This function encrypts data which is provided through a parameter, using AES-128.
     * @param string $dataToEncrypt Data which should be encrypted. This could be an email address, for example.
     * @return string The encrypted version of the data.
     */
    public function encryptData($dataToEncrypt)
    {
        try {
            $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length(self::ENCRYPTION_CIPHER));
            $encrypted = openssl_encrypt($dataToEncrypt, self::ENCRYPTION_CIPHER, $this->encryptionKey);
            return base64_encode($encrypted);
        } catch (Exception $e) {
            MessageManager::sendError(self::GENERIC_ERROR_MESSAGE, 500, "Error encrypting data: " . $e->getMessage());
        }
    }

    /**
     * This function decrypts data, which has been encrypted using AES-128.
     * @param string $dataToDecrypt Data which should be decrypted. This could be a phone number, for example.
     * @return string Plain text of the formerly encrypted data.
     */
    public function decryptData($dataToDecrypt)
    {
        try {
            $dataToDecrypt = base64_decode($dataToDecrypt);
            $iv = substr($dataToDecrypt, 0, openssl_cipher_iv_length(self::ENCRYPTION_CIPHER));
            $cipherText = substr($dataToDecrypt, openssl_cipher_iv_length(self::ENCRYPTION_CIPHER));
            return openssl_decrypt($cipherText, self::ENCRYPTION_CIPHER, $this->encryptionKey, 0, $iv);
        } catch (Exception $e) {
            MessageManager::sendError(self::GENERIC_ERROR_MESSAGE, 500, "Error decrypting data: " . $e->getMessage());
        }
    }

    /**
     * This function creates a Json Web Token and returns the result.
     * @param int $userId Acts as the personal identifier, for the JWT subject.
     * @return string Valid JWT (Json Web Token)
     */
    public function encodeJwt($userId)
    {
        try {
            $payload = [
                'iss' => 'DavidsBookClub',
                'sub' => $userId,
                'iat' => time(),
                'exp' => time() + 86400 // 1 day
            ];

            return JWT::encode(
                $payload,
                Constants::getJwtSecretKey(),
                self::JWT_HASHING_ALGORITHM,
                Constants::getKid()
            );
        } catch (Exception $e) {
            MessageManager::sendError(self::GENERIC_ERROR_MESSAGE, 500, "Error generating JWT: " . $e->getMessage());
        }
    }

    /**
     * This function decodes a Json Web Token, which also serves as validation that it is correct.
     * @param string $jwt The JWT to decode.
     * @return stdClass The decoded JWT payload as an object.
     */
    public static function decodeJwt($jwt)
    {
        try {
            $keyArray = new Key(Constants::getJwtSecretKey(), self::JWT_HASHING_ALGORITHM);
            return JWT::decode($jwt, $keyArray);
        } catch (Exception $e) {
            MessageManager::sendError(self::GENERIC_ERROR_MESSAGE, 500, "Error decoding JWT: " . $e->getMessage());
        }
    }
}
