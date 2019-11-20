def downstream_name = 'java-packaging-howto'

node() {
	stage('Checkout') {
		checkout scm
	}
	stage('Install tools') {
		sh "sudo yum -y install asciidoc dia javapackages-tools m4 make python3-ansi2html"
	}
	stage('Get commit message') {
		env.commit_message = sh(
			script: "echo 'Upstream commit:' `git log -1 --pretty=%B`",
			returnStdout: true
		)
	}
	stage('Build') {
		sh "make antora"
	}
	stage('Deploy') {
		sh "git clone ssh://git@pagure.io/${downstream_name}.git"
		sh "rm -rf ${downstream_name} /modules"
		sh "mv modules ${downstream_name}"
		sh "pushd ${downstream_name}"
		sh "git add modules"
		sh "git commit -m ${commit_message}"
		sh "git push origin master:test"
	}
}
