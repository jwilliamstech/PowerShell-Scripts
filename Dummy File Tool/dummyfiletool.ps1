#Dummy file creation Tool, authored by Joshua Williams.

function Run-DFT {

    #Tool option list
    $fileCreation = New-Object System.Management.Automation.Host.ChoiceDescription '&Create', 'Create'
    $fileDeletion = New-Object System.Management.Automation.Host.ChoiceDescription '&Delete', 'Delete'
    $exit = New-Object System.Management.Automation.Host.ChoiceDescription '&Exit', 'Exit'

    #Prompt for tool options
    $options = [System.Management.Automation.Host.ChoiceDescription[]]($fileCreation, $fileDeletion, $Exit)
    $title = 'Dummy File Tool'
    $message = 'Please select the desired operation.'
    $result = $host.ui.PromptForChoice($title, $message, $options, 0)

    if ($result -eq 0) {

        #Set variables for file generation
        $imageExtensions = "gif","jpeg", "tiff", "png", "pdf","bmp"
        $nameVerbs = "run", "jump", "crawl", "climb", "fly", "sleep", "sit", "laugh", "teach", "dive", "sneak", "play", "rest", "ride", "run", "fall", "cry", "learn", "show", "help", "amaze", "fight", "get", "do", "be", "listen", "love", "drink", "sleep", "pray", "slap", "follow", "throw", "leap", "hang", "cook", "fry", "toss", "jam", "build", "lean", "smile", "frown", "spar", "train", "travel"
        $nameNouns = "rob", "greg", "mike", "sam", "john", "fred", "sally", "lara", "phil", "lucy", "ricky", "larry", "curly", "moe", "connor", "nick", "tony", "dan", "josh", "kevin", "linda", "alex", "alexis", "brad", "don", "erin", "eric", "ethan", "emmit", "troy", "daryl", "dion", "mark", "evan", "brian", "garrett", "cadence", "adam", "jay", "tom", "john", "frank", "julie", "julianna", "sonja", "muhammad", "rhonda", "rachel", "hannah", "cecile"

        #Set file size
        $fileSize = Read-Host "Enter the desired file size value. (E.X. 1mb, 100kb, 10b, etc)"

        #Set total number of files to create
        $totalFiles = Read-Host "How many files would you like to create?"

        #Int64 required for file size
        $fileInt = [int64][scriptblock]::Create($fileSize).Invoke()[0]

        #file location and count
        $filePath = Test-Path -Path C:\temp\dummyfiles\$fileSize

        #Check to see if directory exists. If it doesn't, create the directory.
        if ( -not $filePath ) {
            
            Write-Host "Creating directory..."
            new-item ("C:\temp\dummyfiles\" + $fileSize) -itemtype directory
            $filePath = Test-Path -Path ("C:\temp\dummyfiles\" + $fileSize)

        }

        $dummyFiles = Get-ChildItem C:\temp\dummyfiles\$filesize | Measure-Object
        $fileCount = $dummyFiles.Count

        #Create files
        if ($fileCount -lt $totalFiles) {

            Write-Host "Creating files..."
            do

            {

            $randVerbs = $nameVerbs | Get-Random
            $randNouns = $nameNouns | Get-Random
            $fileNames = $randVerbs + $randNouns
            $fileTypes = $imageExtensions | Get-Random
            $fileCreate = New-object System.IO.FileStream C:\temp\dummyfiles\$fileSize\$fileNames.$fileTypes, Create, ReadWrite
            $fileCreate.SetLength($fileInt)
            $fileCreate.Close()
            $dummyFiles = Get-ChildItem ("C:\temp\dummyfiles\" + $fileSize) | Measure-Object
            $fileCount = $dummyFiles.Count

            }

            until ($fileCount -eq $totalFiles)
            Run-DFT

        }

    }

    elseif ($result -eq 1) {

        $directory = Get-ChildItem -Path c:\temp\dummyfiles
        Write-Host $directory
        $folderDeletion = Read-Host "Which folder would you like to delete?"
        Write-Host "Deleting directory..."
        $deletionPath = "C:\temp\dummyfiles\" + $folderDeletion

        #Delete directory
        Remove-Item -Recurse -Force $deletionPath
        Run-DFT

    }

}

Run-DFT