SUBDIRS = omnibus-centos6 omnibus-centos7 omnibus-precise omnibus-trusty omnibus-wheezy

.PHONY: subdirs $(SUBDIRS)

subdirs: $(SUBDIRS)


images:
		for dir in $(SUBDIRS); do \
			cd $$dir && docker build --rm -t $$dir-base .; \
			cd -; \
		done

.PHONY: images
