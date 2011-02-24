
function Test-ProjectNameReturnsUniqueName {
     # Arrange
     $f = New-SolutionFolder 'Folder1'
     $p1 = $f | New-ClassLibrary 'ProjectA'
     $p3 = $f | New-WebApplication 'ProjectB'

     $p2 = New-ConsoleApplication 'ProjectA'

     # Act
     $projectUniqueNames = @(Get-Project -All | Select-Object -ExpandProperty ProjectName)

     # Assert
     Assert-True ($projectUniqueNames.Count -eq 3)
     Assert-AreEqual 'Folder1\ProjectA' $projectUniqueNames[0]
     Assert-AreEqual 'Folder1\ProjectB' $projectUniqueNames[1]
     Assert-AreEqual 'ProjectA' $projectUniqueNames[2]
}

function Test-DefaultProjectIsCorrectWhenProjectsAreAdded {
    # Act
    $f1 = New-SolutionFolder 'Folder1'
    $p1 = $f1 | New-ClassLibrary 'ProjectA'

    # Assert
    Assert-DefaultProject $p1

    # Act
    $p2 = New-ClassLibrary 'Projecta'
    Assert-DefaultProject $p1
}

function Test-GetProjectCommandWithWildCardsWorksWithProjectHavingTheSameName {
    #
    #  Folder1
    #     + ProjectA
    #     + ProjectB
    #  Folder2
    #     + ProjectA
    #     + ProjectC
    #  ProjectA
    #

    # Arrange
    $f = New-SolutionFolder 'Folder1'
    $p1 = $f | New-ClassLibrary 'ProjectA'
    $p2 = $f | New-ClassLibrary 'ProjectB'

    $g = New-SolutionFolder 'Folder2'
    $p3 = $g | New-ClassLibrary 'ProjectA'
    $p4 = $g | New-ConsoleApplication 'ProjectC'

    $p5 = New-ConsoleApplication 'ProjectA'

    # Assert
    Assert-AreEqual $p1 (Get-Project 'Folder1\ProjectA')
    Assert-AreEqual $p2 (Get-Project 'Folder1\ProjectB')
    Assert-AreEqual $p2 (Get-Project 'ProjectB')
    Assert-AreEqual $p3 (Get-Project 'Folder2\ProjectA')
    Assert-AreEqual $p4 (Get-Project 'Folder2\ProjectC')
    Assert-AreEqual $p4 (Get-Project 'ProjectC')
    Assert-AreEqual $p5 (Get-Project 'ProjectA')

    $s1 = (Get-Project 'Folder1' -ea SilentlyContinue)
    Assert-Null $s1

    $s2 = (Get-Project 'Folder2' -ea SilentlyContinue)
    Assert-Null $s2

    $fs = @( Get-Project 'Folder1*' )
    Assert-AreEqual 2 $fs.Count
    Assert-AreEqual $p1 $fs[0]
    Assert-AreEqual $p2 $fs[1]

    $gs = @( Get-Project '*ProjectA*' )
    Assert-AreEqual 3 $gs.Count
    Assert-AreEqual $p1 $gs[0]
    Assert-AreEqual $p3 $gs[1]
    Assert-AreEqual $p5 $gs[2]
}

function Test-SimpleNameDoNotWorkWhenAllProjectsAreNested {
    # Arrange
    $f = New-SolutionFolder 'Folder1'
    $p1 = $f | New-ClassLibrary 'ProjectA'

    $g = New-SolutionFolder 'Folder2'
    $p2 = $g | New-ClassLibrary 'ProjectA'

    # Assert
    Assert-Throws { (Get-Project -Name 'ProjectA') } "Project 'ProjectA' is not found."
}

function Assert-DefaultProject($p) {
    Assert-AreEqual $p (Get-Project)
}