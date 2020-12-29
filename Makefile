unnamed:
	@Rscript -e 'source("build_.R")'
2:
	@Rscript -e 'source("build_2.R")'
bar:
	@Rscript -e 'source("build_bar.r")'
correct-script:
	@Rscript -e 'source("build_correct-script.R")'
foo:
	@Rscript -e 'source("build_foo.R")'
that:
	@Rscript -e 'source("build_that.r")'
this:
	@Rscript -e 'source("build_this.R")'
