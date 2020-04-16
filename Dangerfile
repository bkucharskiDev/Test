# Configuration
jira_project_id = ""
jira_project_base_url = ""

# Linking JIRA ticket
jira.check(
  key: [jira_project_id ],
  url: jira_project_base_url,
  search_title: true,
  search_commits: false,
  fail_on_warning: false,
  report_missing: false,
  skippable: true
)

### PR contents checks

# Ensure there is JIRA ID in PR title
fail("PR doesn't have JIRA ID in title") if github.pr_title.include? "[#{jira_project_id }-" == false

# Ensure there is a summary for a PR
fail("Please provide a summary in the Pull Request description") if github.pr_body.length < 5

# Check commits - warn if they are not nice
commit_lint.check disable: [:empty_line]
commit_lint.check warn: :all

# Show all build errors, warnings and unit tests results generated from xcodebuild
xcode_summary.ignored_files = 'Pods/**'
xcode_summary.inline_mode = true
xcode_summary.report 'xcodebuild.json'

# Running SwiftLint
swiftlint.lint_files

### Modified files checks

# Checking for TODOs
todoist.message = "Please fix all TODOS"
todoist.warn_for_todos
todoist.print_todos_table

changedFiles = (git.added_files + git.modified_files).select{ |file| file.end_with?(".swift") }

# Checking for prints in modified files
warn("You have print inside modified files!") if `grep -r "print” SourceFiles `.length > 1

# Warning if new header files contains “//  Created by ”
changedFiles.each do |changed_file|
  # filter out only the lines that were added
  addedLines = git.diff_for_file(changed_file).patch.lines.select{ |line| line.start_with?("+") }
  fail("`//  Created by ` lines in header files should be removed") if addedLines.select{ |line| line.include?("//  Created by ") }.count != 0
end

# Fail if diff contains try! or as!
changedFiles.each do |changed_file|
  # filter out only the lines that were added
  addedLines = git.diff_for_file(changed_file).patch.lines.select{ |line| line.start_with?("+") }
  fail("No new force try! or as!") if addedLines.select{ |line| (line.include?("as!") || line.include?("try!")) }.count != 0
end
