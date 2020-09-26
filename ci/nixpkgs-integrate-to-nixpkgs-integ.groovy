def canaries = [
    'hello',
    'ghc',
    'go',
    'nix',
    'postgresql',
    'godot',
    'qgis',
    'rustc',
    'wine'
]

nixosTests = [
    'simple',
    'docker',
    'gnome3',
    'firefox',
    'jenkins',
    'transmission',
    'plasma5',
    'postgis'
]

def generateBuildStage(name) {
    return {
        stage("pkgs.${name}") {
            sh "./nix_configs/ci/build-with-overlays ${WORKSPACE}/nixpkgs ${name}"
        }
    }
}

def canaryBuildStages = canaries.collectEntries {
    ["${it}" : generateBuildStage(it) ]
}


def testStage(name) {
    stage("nixos test ${name}") {
        sh "./nix_configs/ci/test-with-overlays ${WORKSPACE}/nixpkgs/nixos ${name}"
    }
}

def nixosTestStages() {
    nixosTests.each {
        testStage(it)
    }
}

pipeline {
    agent any

    triggers {
        pollSCM('*/2 * * * *')
    }

    options {
        disableConcurrentBuilds()
        timeout(time: 24, unit: 'HOURS')
        buildDiscarder logRotator(daysToKeepStr: '60', numToKeepStr: '100')
    }

    stages {
        stage('checkout nixpkgs') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [
                        [name: 'upstream/nixos-unstable'],
                        [name: 'origin/dev**']
                    ],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                        [$class: 'CheckoutOption', timeout: 20],
                        [$class: 'CloneOption',
                         depth: 0,
                         noTags: true,
                         reference: '',
                         shallow: false,
                         timeout: 20],
                        [$class: 'CleanCheckout'],
                        [$class: 'PreBuildMerge',
                         options: [mergeRemote: 'origin', mergeTarget: 'integ']],
                        [$class: 'RelativeTargetDirectory',
                         relativeTargetDir: 'nixpkgs'],
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [
                        [credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                         name: 'origin',
                         url: 'git@github.com:coreyoconnor/nixpkgs.git'],
                        [name: 'upstream',
                         url: 'https://github.com/NixOS/nixpkgs-channels.git']
                    ]
                ])
            }
        }
        stage('checkout nix_configs') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [
                        [$class: 'SubmoduleOption',
                         disableSubmodules: false,
                         parentCredentials: true,
                         recursiveSubmodules: false,
                         reference: "${WORKSPACE}/nixpkgs",
                         trackingSubmodules: false],
                        [$class: 'CleanCheckout'],
                        [$class: 'PathRestriction',
                         excludedRegions: '',
                         includedRegions: """nixpkgs-config/
                                            |ci/
                                            |nixpkgs-config.nix""".stripMargin()],
                        [$class: 'RelativeTargetDirectory',
                         relativeTargetDir: 'nix_configs']
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [
                        [credentialsId: 'c3424ba9-afc5-4ed8-a707-2dce64c87a9a',
                         name: 'nix_configs-origin',
                         url: 'git@github.com:coreyoconnor/nix_configs.git']
                    ]
                ])
            }
        }

        stage("nixpkgs tests") {
            steps {
                script {
                    // TODO: use hydra
                    // parallel canaryBuildStages
                    canaryBuildStages.each {
                        generateBuildStage(it)
                    }
                }
            }
        }

        stage("nixos tests") {
            steps {
                script {
                    nixosTestStages()
                }
            }
        }

        stage("push to integ") {
            steps {
                dir('nixpkgs') {
                    sh "git push -f origin HEAD:integ"
                }
            }
        }
    }
}
