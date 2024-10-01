<?php
/*
Plugin Name: No admin or administrator
Description: Restricts the use of "admin" and "administrator" in usernames.
Version: 1.0
Author: Me
*/

function restrict_usernames($errors, $sanitized_user_login, $user_email) {
	// User can't use these keywords in their username
	$restricted_keywords = ['admin', 'administrator'];

	// Get the name of the user from the form if the variable is empty
    if (empty($sanitized_user_login) && isset($_POST['user_login'])) {
        $sanitized_user_login = sanitize_user($_POST['user_login']);
    }
    $user_login_lower = strtolower($sanitized_user_login);

	// Search for the restricted keywords in the username
    foreach ($restricted_keywords as $keyword) {
        if (strpos($user_login_lower, $keyword) !== false) {
            $errors->add('username_restricted', __('Error: The username cannot contain "admin" or "administrator".'));
            break;
        }
    }

    return $errors;
}

add_filter('registration_errors', 'restrict_usernames', 10, 3);
add_filter('user_profile_update_errors', 'restrict_usernames', 10, 3);