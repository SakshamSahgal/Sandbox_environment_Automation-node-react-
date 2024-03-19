@echo off

echo "Starting the automation process"
REM Set the directory where you want to clone the repository
set "clone_directory=C:\Projects\CloneTest"
REM Set the URL of the Git repository you want to clone
set "repo_url=https://github.com/SakshamSahgal/SandboxenvironmentAutomation-node-react-"

GOTO:MAIN

REM Check if Git is installed
:CheckGitInstallation
	echo Checking if Git is installed...
	where git >nul 2>nul
	if %errorlevel% neq 0 (
		echo Git is not installed or not found in the system PATH.
		pause
		exit /b 1
	) else (
		echo Git is installed and found in the system PATH.
	)
exit /b 0

REM Delete Automate.bat and .git folder from clone_directory
:DeleteFilesAndFolders
	echo Deleting Automate.bat and .git folder from clone_directory...
	del /Q %clone_directory%\Automate.bat
	rd /S /Q %clone_directory%\.git

	if exist %clone_directory%\Automate.bat (
		echo Failed to delete Automate.bat from clone_directory.
	) else (
		echo Automate.bat deleted successfully from clone_directory.
	)

	if exist %clone_directory%\.git (
		echo Failed to delete .git folder from clone_directory.
	) else (
		echo .git folder deleted successfully from clone_directory.
	)
exit /b 0

REM Clone the repository
:CloneRepository
	echo Cloning the repository...
	git clone %repo_url% %clone_directory%
	if %errorlevel% neq 0 (
		echo An error occurred while cloning the repository.
		pause
		exit /b 1
	) else (
		echo Repository cloned successfully.
	)
exit /b 0

:open_vscode
	echo Opening Visual Studio Code in directory: %1
	if exist "%1" (
		start /B code "%1"
	) else (
		echo Directory not found: %1
		exit /b 1
	)
exit /b 0

:run_npm_install
echo Running npm install in directory: %1
if exist "%1\node_modules\" (
    echo Node modules already installed in directory: %1
) else (
    pushd "%1" && (
        npm install
        popd
    ) || (
        echo Failed to run npm install in directory: %1
        exit /b 1
    )
)
exit /b 0


:MAIN
echo "---------------------------------"
REM Call functions in sequence
call :CheckGitInstallation
echo "---------------------------------"
call :CloneRepository
echo "---------------------------------"
call :DeleteFilesAndFolders
echo "---------------------------------"
call :open_vscode %clone_directory%\Backend
echo "---------------------------------"
call :open_vscode %clone_directory%\Frontend
echo "---------------------------------"
call :run_npm_install %clone_directory%\Backend
echo "---------------------------------"
call :run_npm_install %clone_directory%\Frontend
echo "---------------------------------"

REM Pause to keep the command window open after execution (optional)
pause
