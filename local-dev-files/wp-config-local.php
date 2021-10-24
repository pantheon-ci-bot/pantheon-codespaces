<?php
//Local development environment config file

// Add for Codespaces Apache setup
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO'])) {
    if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
    $_SERVER['HTTPS']='on';
}

// ** Local MySQL settings ** //
/** The name of the database for WordPress */
define('DB_NAME', 'drupal');

/** MySQL database username */
define('DB_USER', 'user');

/** MySQL database password */
define('DB_PASSWORD', '1234');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');
