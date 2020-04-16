# Configuration
jira_project_id = "TEST"
jira_project_base_url = "https://EXAMPLE_URL.com/browse"

# Linking JIRA ticket
jira.check(
  key: [jira_project_id ],
  url: jira_project_base_url,
  search_title: true,
  search_commits: false,
  fail_on_warning: false,
  report_missing: false,
  skippable: false
)

### PR contents checks

# Ensure there is JIRA ID in PR title
is_jira_id_included = github.pr_title.include? "[#{jira_project_id }-"
fail("PR doesn't have JIRA ID in title or it's not correct. PR title should begin with [#{jira_project_id}-") if (is_jira_id_included == false)

# Ensure there is a summary for a PR
fail("Please provide a summary in the Pull Request description") if github.pr_body.length < 5

# Show all build errors, warnings and unit tests results generated from xcodebuild
xcode_summary.ignored_files = 'Pods/**'
xcode_summary.inline_mode = true
xcode_summary.report 'xcodebuild.json'

# Running SwiftLint
swiftlint.lint_files

### Modified files checks

changedFiles = (git.added_files + git.modified_files).select{ |file| file.end_with?(".swift") }
changedFiles.each do |changed_file|
  addedLines = git.diff_for_file(changed_file).patch.lines.select{ |line| line.start_with?("+") }

  # Check for prints in modified files
  warn("There are print statements inside modified files!") if addedLines.select{ |line| line.include?("print(") }.count != 0

  # Check for TODOs in modified files
  warn("There are TODOs inside modified files!") if addedLines.select{ |line| line.include?("TODO") | line.include?("todo") }.count != 0

  # Warn if new header files contains “//  Created by ”
  fail("`//  Created by ` lines in header files should be removed") if addedLines.select{ |line| line.include?("//  Created by ") }.count != 0
end

# Check commits - warn if they are not nice
commit_lint.check warn: :all
