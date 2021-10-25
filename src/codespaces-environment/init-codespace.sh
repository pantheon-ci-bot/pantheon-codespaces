# A script for initializing codespace dev env.
# Note the script is intended to be run at root of project.
# It needs to be adjusted for projects using a non-web docroot.

# Change dir to Codespace home
cd /workspaces/$(echo $RepositoryName)
# Add local dev commands to terminal path
SOURCE_PREFIX="PATH=\"$(pwd)/.devcontainer/src/pantheon-commands"
SOURCE_SUFFIX=':$PATH"'
echo "$(echo $SOURCE_PREFIX)$(echo $SOURCE_SUFFIX)" >> ~/.bashrc
echo "alias repair-codespace=\"/workspaces/$(echo $RepositoryName)/.devcontainer/src/init-codespace.sh\"" >> ~/.bashrc
echo "alias uli=\"drush uli --uri=https://$CODESPACE_NAME-8080.githubpreview.dev\"" >> ~/.bashrc
echo "export CODESPACE_URL=\"$CODESPACE_NAME-8080.githubpreview.dev\"" >> ~/.bashrc
# Add local vendor/bin to allow drush to PATH
DRUSH_SOURCE_PREFIX="PATH=\"$(pwd)/vendor/bin"
DRUSH_SOURCE_SUFFIX=':$PATH"'
echo "$(echo $DRUSH_SOURCE_PREFIX)$(echo $DRUSH_SOURCE_SUFFIX)" >> ~/.bashrc
source ~/.bashrc
# Setup wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
# Setup terminus
pantheon-install-terminus > /dev/null 2>&1
# Setup apache with project folder name
PROJECT_NAME=$(pwd)
echo "Initializing $PROJECT_NAME" 
sudo chmod o+rw /etc/apache2/sites-available/000-default.conf
sudo cat > /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:8080>

  ServerAdmin webmaster@localhost
  DocumentRoot $PROJECT_NAME/

  <Directory $PROJECT_NAME/>
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
EOF
# Start up mysql and initialize dev user.
sudo service mysql start
bash .devcontainer/src/mysql-init.sh
# Copy over xdebug config
sudo cp .devcontainer/src/20-xdebug.ini /etc/php/7.4/cli/conf.d/20-xdebug.ini
# Start up apache.
sudo apachectl start
# Add ssh key for usage.
echo "$SSH_KEY" > /home/vscode/.ssh/id_rsa && chmod 600 /home/vscode/.ssh/id_rsa
