#!/bin/bash

# This script provides a complete set of user management operations.
# It works on Oracle Linux, Kali Linux, and Ubuntu (WSL) environments.
# Each operation includes tasks such as creating, modifying, deleting users,
# locking/unlocking accounts, changing user shells, setting expiration dates, and more.

# Function to create a new user
create_user() {
  # Prompt the admin for the new username
  read -p "Enter username to create: " username
  
  # Add the user to the system with a home directory
  sudo useradd -m "$username"
  
  # Set the password for the user
  sudo passwd "$username"
  echo "User $username created successfully."
}

# Function to modify an existing user
modify_user() {
  # Prompt for the username to modify
  read -p "Enter the username to modify: " username
  
  # Display a list of modification options
  echo "What do you want to modify?"
  echo "1. Change password"
  echo "2. Add to group"
  echo "3. Change shell"
  echo "4. Lock account"
  echo "5. Unlock account"
  echo "6. Set account expiration date"
  echo "7. Set/change full name"
  read -p "Choose an option (1-7): " option
  
  case $option in
    1)
      # Change the user’s password
      sudo passwd "$username"
      ;;
    2)
      # Add the user to a new group
      read -p "Enter group name to add $username: " group
      sudo usermod -aG "$group" "$username"
      ;;
    3)
      # Change the user’s shell
      read -p "Enter new shell for $username (e.g., /bin/bash): " shell
      sudo usermod -s "$shell" "$username"
      ;;
    4)
      # Lock the user’s account
      sudo usermod -L "$username"
      echo "User $username is now locked."
      ;;
    5)
      # Unlock the user’s account
      sudo usermod -U "$username"
      echo "User $username is now unlocked."
      ;;
    6)
      # Set an account expiration date (e.g., 2024-12-31)
      read -p "Enter expiration date (YYYY-MM-DD) for $username: " exp_date
      sudo usermod -e "$exp_date" "$username"
      echo "Expiration date set for $username."
      ;;
    7)
      # Change the full name of the user (GECOS field)
      read -p "Enter full name for $username: " full_name
      sudo usermod -c "$full_name" "$username"
      echo "Full name updated for $username."
      ;;
    *)
      echo "Invalid option!"
      ;;
  esac
}

# Function to delete a user
delete_user() {
  # Prompt for the username to delete
  read -p "Enter username to delete: " username
  
  # Delete the user and their home directory
  sudo userdel -r "$username"
  echo "User $username deleted successfully."
}

# Function to show user details (ID, groups, etc.)
show_user_details() {
  # Prompt for the username to display details
  read -p "Enter username to view details: " username
  
  # Display user ID, group ID, and groups
  sudo id "$username"
  
  # Show password aging details (e.g., account expiration, last password change)
  sudo chage -l "$username"
}

# Function to list all users on the system
list_all_users() {
  echo "Listing all users on the system:"
  cut -d: -f1 /etc/passwd
}

# Function to find which groups a user is part of
find_user_groups() {
  read -p "Enter username to find groups: " username
  groups "$username"
}

# Function to set user password expiration
set_password_expiration() {
  read -p "Enter username to set password expiration: " username
  read -p "Enter the number of days until password expires: " days
  sudo chage -M "$days" "$username"
  echo "Password expiration set for $username to $days days."
}

# Function to disable user login temporarily (password aging)
disable_user_login() {
  read -p "Enter username to disable login for: " username
  sudo usermod -L "$username"
  echo "User login for $username is disabled temporarily."
}

# Main menu with all the options
echo "User Management Script for Oracle Linux / Kali Linux / Ubuntu on WSL"
echo "1. Create User"
echo "2. Modify User"
echo "3. Delete User"
echo "4. Show User Details"
echo "5. List All Users"
echo "6. Find User's Groups"
echo "7. Set Password Expiration"
echo "8. Disable User Login Temporarily"
read -p "Choose an option (1-8): " choice

case $choice in
  1) create_user ;;
  2) modify_user ;;
  3) delete_user ;;
  4) show_user_details ;;
  5) list_all_users ;;
  6) find_user_groups ;;
  7) set_password_expiration ;;
  8) disable_user_login ;;
  *)
    echo "Invalid choice!"
    ;;
esac
