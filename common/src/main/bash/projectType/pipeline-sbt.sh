#!/bin/bash

set -e

export SBT_BIN
SBT_BIN="${SBT_BIN:-./sbt}"

# It takes ages on Docker to run the app without this
if [[ ${BUILD_OPTIONS} != *"java.security.egd"* ]]; then
	if [[ ! -z ${BUILD_OPTIONS} && ${BUILD_OPTIONS} != "null" ]]; then
		export BUILD_OPTIONS="${BUILD_OPTIONS} -Djava.security.egd=file:///dev/urandom"
	else
		export BUILD_OPTIONS="-Djava.security.egd=file:///dev/urandom"
	fi
fi

function build() {
	# TODO: apply sbt configuration/commands for build
}

function apiCompatibilityCheck() {
	local prodTag="${PASSED_LATEST_PROD_TAG:-${LATEST_PROD_TAG:-}}"
	[[ -z "${prodTag}" ]] && prodTag="$(findLatestProdTag)"
	echo "Last prod tag equals [${prodTag}]"
	if [[ -z "${prodTag}" ]]; then
		echo "No prod release took place - skipping this step"
	else
		# Putting env vars to output properties file for parameter passing
		export PASSED_LATEST_PROD_TAG="${prodTag}"
		local fileLocation="${OUTPUT_FOLDER}/test.properties"
		mkdir -p "${OUTPUT_FOLDER}"
		echo "PASSED_LATEST_PROD_TAG=${prodTag}" >>"${fileLocation}"
		# Downloading latest jar
		LATEST_PROD_VERSION=${prodTag#prod/}
		echo "Last prod version equals [${LATEST_PROD_VERSION}]"
		if [[ "${CI}" == "CONCOURSE" ]]; then
			# shellcheck disable=SC2086
			# TODO: execute similar command for SBT (for now I don't have a clue how it looks like)
		else
			# shellcheck disable=SC2086
			# TODO: execute similar command for SBT (for now I don't have a clue how it looks like)
		fi
	fi
}

# The function uses SBT Script - if you're using SBT you have to have it on your classpath
# and change this function
function extractSbtProperty() {
	local prop="${1}"
	# TODO: Find how to actually extract the property in SBT
}

function retrieveGroupId() {
	{
		ruby -r rexml/document  \
 -e 'puts REXML::Document.new(File.new(ARGV.shift)).elements["/project/groupId"].text' pom.xml  \
 || "${SBT_BIN}" org.apache.maven.plugins:maven-help-plugin:2.2:evaluate  \
 -Dexpression=project.groupId | grep -Ev '(^\[|Download\w+:)'
	} | tail -1
}

function retrieveAppName() {
	{
		ruby -r rexml/document  \
 -e 'puts REXML::Document.new(File.new(ARGV.shift)).elements["/project/artifactId"].text' pom.xml  \
 || "${SBT_BIN}" org.apache.maven.plugins:maven-help-plugin:2.2:evaluate  \
 -Dexpression=project.artifactId | grep -Ev '(^\[|Download\w+:)'
	} | tail -1
}

function printTestResults() {
	# shellcheck disable=SC1117
	echo -e "\n\nBuild failed!!! - will print all test results to the console (it's the easiest way to debug anything later)\n\n" && tail -n +1 "$(testResultsAntPattern)"
}

function retrieveStubRunnerIds() {
	extractSbtProperty 'stubrunner.ids'
}

function runSmokeTests() {
	local applicationUrl="${APPLICATION_URL}"
	local stubrunnerUrl="${STUBRUNNER_URL}"
	echo "Running smoke tests. Application url [${applicationUrl}], Stubrunner Url [${stubrunnerUrl}]"

	if [[ "${CI}" == "CONCOURSE" ]]; then
		# shellcheck disable=SC2086
		# TODO: execute similar command for SBT (for now I don't have a clue how it looks like)
	else
		# shellcheck disable=SC2086
		# TODO: execute similar command for SBT (for now I don't have a clue how it looks like)
	fi
}

function runE2eTests() {
	local applicationUrl="${APPLICATION_URL}"
	echo "Running e2e tests for application with url [${applicationUrl}]"

	if [[ "${CI}" == "CONCOURSE" ]]; then
		# shellcheck disable=SC2086
		# TODO: execute similar command for SBT (for now I don't have a clue how it looks like)
	else
		# shellcheck disable=SC2086
		# TODO: execute similar command for SBT (for now I don't have a clue how it looks like)
	fi
}

function outputFolder() {
	echo "target"
}

function testResultsAntPattern() {
	echo "**/surefire-reports/*"
}

export -f build
export -f apiCompatibilityCheck
export -f runSmokeTests
export -f runE2eTests
export -f outputFolder
export -f testResultsAntPattern
