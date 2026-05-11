# Pyomo - Tutorials

**Pages:** 17

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#contribution-requirements

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#working-with-my-fork-and-the-github-online-ui

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#coding-standards

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#working-on-forks-and-branches

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#forksgithubui

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#review-process

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#pyomo-contrib

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#where-to-put-contributed-code

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#forksremotes

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#testing

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#python-version-support

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#setting-up-your-development-environment

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#contributing-to-pyomo

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#contrib-packages-within-pyomo

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#working-with-remotes-and-the-git-command-line

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---

## Contributing to Pyomo — Pyomo 6.10.0.dev0 documentation

**URL:** https://pyomo.readthedocs.io/en/latest/contribution_guide.html#using-github-ui-to-merge-pyomo-main-into-a-branch-on-your-fork

**Contents:**
- Contributing to Pyomo
- Contribution Requirements
  - Coding Standards
  - Testing
  - Python Version Support
- Working on Forks and Branches
  - Working with my fork and the GitHub Online UI
    - Using GitHub UI to merge Pyomo main into a branch on your fork
  - Working with remotes and the git command-line
  - Setting up your development environment

We welcome all contributions including bug fixes, feature enhancements, and documentation improvements. Pyomo manages source code contributions via GitHub pull requests (PRs).

A PR should be 1 set of related changes. PRs for large-scale non-functional changes (i.e. PEP8, comments) should be separated from functional changes. This simplifies the review process and ensures that functional changes aren’t obscured by large amounts of non-functional changes.

We do not squash and merge PRs so all commits in your branch will appear in the main history. In addition to well-documented PR descriptions, we encourage modular/targeted commits with descriptive commit messages.

Inside pyomo.contrib: Contact information for the contribution maintainer (such as a Github ID) should be included in the Sphinx documentation

The first step of Pyomo’s GitHub Actions workflow is to run black and a spell-checker to ensure style guide compliance and minimize typos. Before opening a pull request, please run:

If the spell-checker returns a failure for a word that is spelled correctly, please add the word to the .github/workflows/typos.toml file. Note also that black reads from pyproject.toml to determine correct configuration, so if you are running black indirectly (for example, using an IDE integration), please ensure you are not overriding the project-level configuration set in that file.

Online Pyomo documentation is generated using Sphinx with the napoleon extension enabled. For API documentation we use of one of these supported styles for docstrings, but we prefer the NumPy standard. Whichever you choose, we require compliant docstrings for:

Public and Private Classes

Public and Private Functions

We also encourage you to include examples, especially for new features and contributions to pyomo.contrib.

Pyomo uses unittest, pytest, GitHub Actions, and Jenkins for testing and continuous integration. Submitted code should include tests to establish the validity of its results and/or effects. Unit tests are preferred but we also accept integration tests. We require at least 70% coverage of the lines modified in the PR and prefer coverage closer to 90%. We also require that all tests pass before a PR will be merged.

If you are having issues getting tests to pass on your Pull Request, please tag any of the core developers to ask for help.

The Pyomo main branch provides a Github Actions workflow (configured in the .github/ directory) that will test any changes pushed to a br

*[Content truncated]*

---
