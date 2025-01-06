# Prompt the user for the top-level ROM directory to search
$searchDirectory = Read-Host "Enter the top-level ROM directory to search. Example: E:\ROMs"

# Prompt the user for the output directory for the .cfg files
$outputDirectory = Read-Host "Enter the output directory for your collection .cfg files. Example: E:\ES-DE\collections"

# Prompt the user for the directory to export the XML file
$xmlExportDirectory = Read-Host "Enter the directory to save the XML files. Example: E:\themes_tempoary\_inc\systems\metadata-global\"

# Ensure the XML export directory exists
if (-not (Test-Path -Path $xmlExportDirectory)) {
    New-Item -ItemType Directory -Path $xmlExportDirectory | Out-Null
}

# Main loop
do {
    # Prompt the user for a search term
    $searchTerm = Read-Host "Enter the search term"

    # Prompt the user for the name of the output file (without extension)
    $outputFileName = Read-Host "Enter the name for the output file (without extension). Example: Tecmo Super Bowl"

    # Define the output file path for the .cfg file
    $outputFile = Join-Path -Path $outputDirectory -ChildPath "custom-$outputFileName.cfg"

    # Ensure the .cfg output directory exists
    if (-not (Test-Path -Path $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory | Out-Null
    }

    # Read existing lines from the .cfg file if it exists
    $existingLines = @()
    if (Test-Path -Path $outputFile) {
        $existingLines = Get-Content -Path $outputFile
    }

    # Perform the search
    $results = Get-ChildItem -Path $searchDirectory -Recurse -File |
        Where-Object { $_.Name -match $searchTerm }

    # If no results are found, notify the user and continue
    if ($results.Count -eq 0) {
        Write-Host "No files found matching the search term '$searchTerm'."
        continue
    }

    # Ask the user if they want to add all results at once
    $addAll = Read-Host "Add all found results to the collection? (Y/N)"

    # Initialize an empty list for selected results
    $selectedResults = @()

    if ($addAll -eq "Y") {
        # Add all results, skipping duplicates
        foreach ($result in $results) {
            $relativePath = $result.FullName -replace "^E:\\", "%ROMPATH%/" -replace "\\", "/" -replace "/Roms", ""
            if ($existingLines -notcontains $relativePath) {
                $selectedResults += $relativePath
            } else {
                Write-Host "Skipped duplicate: $relativePath"
            }
        }
    } else {
        # Prompt the user for each result
        foreach ($result in $results) {
            $relativePath = $result.FullName -replace "^E:\\", "%ROMPATH%/" -replace "\\", "/" -replace "/Roms", ""
            if ($existingLines -notcontains $relativePath) {
                $userChoice = Read-Host "Add this file to the collection? (y/n): $relativePath"
                if ($userChoice -eq "y") {
                    $selectedResults += $relativePath
                }
            } else {
                Write-Host "Skipped duplicate: $relativePath"
            }
        }
    }

    # Append selected results to the .cfg file
    if ($selectedResults) {
        $selectedResults | Out-File -FilePath $outputFile -Encoding UTF8 -Append
        Write-Host "Selected files have been appended to $outputFile"
    } else {
        Write-Host "No new files were selected."
    }

    # Define the XML content
    $xmlContent = @"
<theme>
   <variables>
      <systemName>$outputFileName</systemName>
      <systemDescription>View and play the $outputFileName games in your collection.</systemDescription>
      <systemManufacturer>Various</systemManufacturer>
      <systemReleaseYear>Various</systemReleaseYear>
      <systemReleaseDate>Various</systemReleaseDate>
      <systemReleaseDateFormated>Various</systemReleaseDateFormated>
      <systemHardwareType>Various</systemHardwareType>
      <systemCoverSize>1-1</systemCoverSize>
      <systemColor>3F549D</systemColor>
      <systemColorPalette1>FED01B</systemColorPalette1>
      <systemColorPalette2>BA2318</systemColorPalette2>
      <systemColorPalette3>0A2A8D</systemColorPalette3>
      <systemColorPalette4>007544</systemColorPalette4>
      <systemCartSize>1-1</systemCartSize>
   </variables>
</theme>
"@

    # Define the XML file path
    $xmlFilePath = Join-Path -Path $xmlExportDirectory -ChildPath "$outputFileName.xml"

    # Write the XML content to the file
    $xmlContent | Out-File -FilePath $xmlFilePath -Encoding UTF8
    Write-Host "XML file created successfully at $xmlFilePath"

    # Prompt to start over
    $startOver = Read-Host "Would you like to start over with a new search term? (Y/N)"
} while ($startOver -eq "Y")

Write-Host "Script completed. Goodbye!"
