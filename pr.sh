#!/bin/bash



login(){
echo "----------------------------------------"
echo "Attempting to log in to GitHub..."
echo "----------------------------------------"
gh auth login
}

status(){
gh auth status
}

create_repo(){
echo "----------------------------------------"
echo "Attempting to create a new repository..."
echo "----------------------------------------"

 git config --global user.name "Ashu Gupta"
    git config --global user.email "ashugt73@gmail.com"


 git config --global --add safe.directory "$(pwd)"
read -p "Enter the name for the repository: " repo

if [ -z "$repo" ]; then
        echo "Repository name cannot be empty."
        return
fi


read -p "Enter the description for the repo/project: " desc

echo "Select repo visibility"
echo "1. Public"
echo "2. Private"
read -p "Enter your choice (public/private): " choice

if [ "$choice" == "1" ]; then
	visibility="--public"
elif [ "$choice" == "2" ]; then
	visibility="--private"
else
	echo "Invalid choice. Redirecting to Public."
	visibility="--public"
fi

echo
echo "Creating repository '$repo' ..."
gh repo create "$repo" $visibility --description "$desc"

echo "----------------------------------------"
echo "Repo created successfully" "$repo"
echo "Description" "$desc"
echo "Visibility: $visibility"
echo "----------------------------------------" 

username=$(gh api user --jq '.login')

url="https://github.com/$username/$repo.git"

if [ -d .git ]; then
        echo "Deleting previous .git folder..."
        rm -rf .git
    fi



#Initialize and connect to repo

git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin "$url"
git push -u origin main


}

push(){

echo "----------------------------------------"
echo "Attempting to push all the work into your repository..."
echo "----------------------------------------"

if [ ! -d .git ]; then
        echo "This folder is not a Git repository!"
        echo "Run 'Create Repository' option first."
        return
    fi





read -p "Enter the message for this commit: " commit
if [ -z "$commit" ]; then
        commit="Updated project work"
    fi




git status
git add .
git commit -m "$commit"

echo "Pushing to GitHub..."
git push origin main
}

connect_existing_repo() {
    echo "----------------------------------------"
    echo "Fetching your GitHub repositories..."
    echo "----------------------------------------"

    repos=$(gh repo list --limit 50 --json name,url --jq '.[] | "\(.name) \(.url)"')

    if [ -z "$repos" ]; then
        echo "❌ No repositories found on your GitHub account."
        return
    fi

    i=1
    echo "Select a repository to connect:"
    while read -r line; do
        echo "$i) $line"
        repos_arr[$i]="$line"
        ((i++))
    done <<< "$repos"

    read -p "Enter your choice: " choice

    selected="${repos_arr[$choice]}"
    repo_url=$(echo "$selected" | awk '{print $2}')

    echo "----------------------------------------"
    echo "Connecting to $repo_url"
    echo "----------------------------------------"

    # Remove old origin
    if git remote | grep -q origin; then
        git remote remove origin
    fi

    # Add new origin
    git remote add origin "$repo_url.git"

    # Ensure branch is main
    git branch -M main

    echo "Saving your local changes temporarily (stash)..."
    git stash push -m "temp-stash-for-merge"

    echo "Pulling existing commits from GitHub (merging histories)..."
    git pull origin main --allow-unrelated-histories --no-rebase

    echo "Applying your local changes back..."
    git stash pop

    echo "----------------------------------------"
    echo "✔ Successfully connected and merged remote commits!"
    echo "You can now push safely using your push() function."
    echo "----------------------------------------"
}



echo "Main Menu"
echo "1. Login into the github"
echo "2. Check the status of your github Account"
echo "3. Create a repository"
echo "4. Add all your work on your github Account"
echo "5. Add your work in another repository"
echo "6. Check all the existing repositories"


read -p "Enter the choice: " choice



case "$choice" in 
1) echo "You selected: Login into the github"
	login
;;

2) echo "You selected: Check you account status"
	status
;;

3) echo "You selected: Create a repository"
	create_repo
;;

4) echo "You selected: Add all work onto github"
	push
;;

5)
	connect_existing_repo
;;

*)

echo "Invalid choice"
;;
esac
