# Table of Contents

- [Contributing a _Bioconductor_ Package](#contributing-a-bioconductor-package)
- [Starting the Submission Process](#starting-the-submission-process)
- [What to Expect](#what-to-expect)
- [Adding a Web Hook](#adding-a-web-hook)
- [Submitting Related Packages](#submitting-related-packages)
  - [Circular Dependencies](#circular-dependencies)
- [Additional Actions](#additional-actions)
- [Resources](#resources)

# Contributing a _Bioconductor_ Package

This repository is used to contribute new packages to the
[Bioconductor][1] project for the analysis and comprehension of
high-throughput genomic data. Please

- Review the [package submission][7] process.

- Ensure that your package conforms to our [package guidelines][6].

- Ask questions about new package submission on the [bioc-devel][9]
  mailing list.

By using this service, please note that:

* Your package code will be visible to the general public, where
  anyone can see it.

* The build reports and comments during the review process are public.

* Any GitHub user may add comments to the package review.

* You are submitting a package for inclusion in _Bioconductor_; the
  build service we provide is meant only for individuals submitting
  _Bioconductor_ packages.

## Starting the Submission Process

To submit a package to _Bioconductor_:

1. Create your own [GitHub repository][2], containing source code
   structured as an _R_ package. The source code must be in a
   default 'master' branch of your GitHub repository.

1. [Add SSH public key(s)][12] to your GitHub account. The SSH key
   pair will be used after package acceptance for updating the
   Bioconductor git repository.

1. [Open a new issue][5]. Complete the issue by adding the link to
   your repository, and confirming that you understand the review
   process, package guidelines, and maintainer
   responsibilities. Provide the name of your package as the 'Title'
   of the issue.

1. [Add a webhook][3] to your repository. The webhook means that any
   commit to the default 'master' branch automatically triggers a new
   package build.

## What to Expect

* A new package is initially labeled as '1. awaiting moderation'.
  A _Bioconductor_ team member will take a very brief look at your
  package, to ensure that it is intended for _Bioconductor_. Appropriate
  packages will be re-labelled '2. review in progress'.

* The package will be submitted to the _Bioconductor_ build
  system. The system will check out your package from GitHub. It will
  then run `R CMD build` to create a 'tarball' of your source code,
  vignettes, and man pages. It will run `R CMD check` on the tarball,
  to ensure that the package conforms to standard _R_ programming best
  practices. Finally, the build system will run `R CMD BiocCheck` to
  ensure that the package conforms to _Bioconductor_ [BiocCheck][4]
  standards. The system will perform these steps using the
  ['devel' version](https://bioconductor.org/developers/how-to/useDevel/)
  of _Bioconductor_, on three platforms (Linux, Mac OS X, and
  Windows).  After these steps are complete, a link to a build report
  will be appended to the new package issue. Avoid surprises by
  running these checks on your own computer, under the 'devel' version
  of _Bioconductor_, before submitting your package.

* If the build report indicates problems, modify your package and
  commit changes to the default branch of your GitHub repository.  If
  there are problems that you do not understand, seek help on the
  [bioc-devel][9] mailing list.

* To trigger a new build, include a version bump in your commit, e.g.,
  from `Version: 0.99.0` to `Version: 0.99.1`.

* Once your package builds and checks without errors or (avoidable)
  warnings, a _Bioconductor_ team member will provide a technical
  review of your package.  Other _Bioconductor_ developers and users
  with domain expertise are encouraged to provide additional community
  commentary.  Reviewers will add comments to the issue you created.

* Respond to the issues raised by the reviewers. You _must_ respond to
  the primary reviewer, and are strongly encouraged to consider
  community commentary. Typically your response will involve code
  modifications; commit these to the default branch of your GitHub
  repository to trigger subsequent builds. When you have addressed all
  concerns, add a comment to the issue created in step 2 to explain
  your response.

* The reviewer will assess your responses, perhaps suggesting further
  modifications or clarification. The reviewer will then accept your
  package for inclusion in _Bioconductor_, or decline it. The label
  '2. review in progress' will be replaced by '3a. accepted' or
  '3b. declined'.

* If your package is accepted, it will be added to _Bioconductor_'s
  Git source control repository and to the nightly 'devel'
  builds. All packages in the 'devel' branch of the repository are
  'released' to the user community once every six months, in
  approximately April and October.

* Once the review process is complete, the issue you created will be
  closed. All updates to your package will be through the
  _Bioconductor_ [Git repository][10] (optionally,
  [using GitHub][11]).

## Adding a Web Hook

To add a web hook:

1. Go to your repository page on GitHub. The link to it will look
   something like this:

	https://github.com/yourusername/yourpackagename

   Of course, `yourusername` and `yourpackagename` will be different.

2. Click on `Settings`, which is currently located towards the top, on
   the right-hand side of the page.

3. In the left hand `Options` section, click on `Webhooks`.

4. Click on `Add webhook`.

5. Paste the following URL into the `Payload URL` box, leaving the
   other settings alone:

	http://issues.bioconductor.org

6. Confirm that the `Content type` drop-down menu has
   `application/json` selected.

7. Click `Add webhook`.

8. The page will be updated to include a link to the web hook. Click
   on the link. A 'Recent Deliveries' area should contain a single
   request. Click on the Request and view the "Response" tab. There
   should be a green `200` response code, with body `ping received,
   Bioconductor/Contributions webhook ok`.

Subsequent pushes to the default `master` branch of your
repository will now trigger builds (only if the package version
has been bumped), and the build reports will be
posted to the issue you created in this repository.  Note that pushes
to branches that are not `master`, or non-default branches, are ignored.

## Submitting Related Packages

Sometimes it is appropriate to contribute more than one package at a
time. The most common case is when a software package has a companion
experiment data package used for illustrative purposes in the
vignette. Remember to avoid circular dependencies between packages.

1. Start by submitting the package that can be installed without a
   dependency on any of the other packages you are submitting (this is
   usually the experiment data package). Do this by creating a
   [new issue][5] as described above.

2. Continue working with this package until it builds and checks
   without error on any platform.

3. Submit additional packages to the same issue. Do this by posting a
   comment containing a line like:

	AdditionalPackage: https://github.com/username/repositoryname

   Include only one `AdditionalPackage` line per comment.  Wait until
   this related package builds before submitting further related
   packages. Do this only after the first build has posted for original package
   submitted and the package has been awarded a `review in progress` label.

4. The `AdditionalPackage` comment must be posted by the same GitHub
   user who created the issue. Also, the initial package submitted in
   the issue must have completed the 'moderation' step. If these
   conditions are not met, the additional package will not build.

5. [Add a webhook][3] for each additional package, so that any changes
   (accompanied by a version bump) trigger a new build.

### Circular Dependencies

If circular dependencies are truly unavoidable, there are some subtle differences
from the above. Bioconductor will support a 'Suggest / Depend' circular
dependency. Most often an accompanied data package will "Suggest" the software
package, while the software package will "Depend" on the data package. The
single package builder (SPB) handles this case by providing each issue with a
unique Rlib path for additional package dependencies. The SPB will install each
package before tryng to build or check.

1. Start by submitting the package with the weaker circular dependency (the
   package that "Suggests" the other package, most often this will be the data
   package). Do this by creating a [new issue][5] as described above. We will
   call this package A.

2. This package A will `ERROR` when running R CMD build. This is expected since
   the additional package B would not be found yet.

3. Submit the additional packages to the same issue. Do this by posting a
   comment containing a line like:

	AdditionalPackage: https://github.com/username/repositoryname

4. This package B will also `ERROR` when running R CMD build. This is expected.

6. [Add a webhook][3] for each package, so that any changes
   (accompanied by a version bump) trigger a new build.

7. Now, perform a version bump on the package A. It should find package B and
   not `ERROR` for a missing dependency. Continue working with package A until it
   builds and checks without error on any platform. 

8. Perform a version bump on package B. It should now find package A and not
   `ERROR` for its missing dependency. Continue with the review process.

## Additional Actions

To change the repository of your package during the review process:

1. Edit the first comment in the issue associated with your
   package. Change the Repository: link to point to your new
   repository.
2. [Add a webhook][3] to the new repository (and remove the
   corresponding web hook from the old repository).
3. Post a comment in your issue, including @mtmorgan, indicating that
   you have changed the repository.
4. Once the comment is acknowledged, bump the package version in the
   new repository to trigger a new build.

To remove an AdditionalPackage: dependency, e.g., because you have
identified AnnnotationHub or other resources that make your additional
package unnecessary:

1. Delete or edit all comments with an `AdditionalPackage:` tag.

To debug package commits that don't trigger a response on the
corresponding issue:

1. Verify that the [web hook][3] is in place.

2. Review 'Recent Deliveries', especially those marked as failures
   (red triangle with exclamation mark).  Click on the checksum, look
   at the 'Response' body.

3. If the response body says 'Failed to parse JSON', verify that the
   web hook (in your repository, 'Settings', 'Webhooks', 'Edit' the
   web hook you've added) has 'Content type:' equal to
   `application/json`.

4. After debugging, click the 'Redeliver' button.

## Resources

The following pages contain more information about package submission.

* [Package Submission][7].
* [Package Guidelines][6].
* The above and many other developer resources are available at the
  [developers' page][8].

If you have a question not answered above, please ask on the
[bioc-devel][9] mailing list.

[1]: https://bioconductor.org
[2]: https://help.github.com/articles/create-a-repo/
[3]: #adding-a-web-hook
[4]: https://bioconductor.org/packages/devel/bioc/html/BiocCheck.html
[5]: ../../issues/new
[6]: https://bioconductor.org/developers/package-guidelines/
[7]: https://bioconductor.org/developers/package-submission/
[8]: https://bioconductor.org/developers/
[9]: https://stat.ethz.ch/mailman/listinfo/bioc-devel
[10]: http://bioconductor.org/developers/how-to/source-control/
[11]: http://bioconductor.org/developers/how-to/git-mirrors/
[12]: https://help.github.com/articles/connecting-to-github-with-ssh/
