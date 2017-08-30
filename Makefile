BUILD_DIR = build

# The release target will perform additional optimization
.PHONY : release
release: $(BUILD_DIR)
	cd $(BUILD_DIR); \
	cmake -DCMAKE_BUILD_TYPE=Release ..

# Also build a shared library
.PHONY : shared
shared: $(BUILD_DIR)
	cd $(BUILD_DIR); \
	cmake -DCMAKE_BUILD_TYPE=Release -DSHAREDBUILD=1 ..

# Build zip file package
.PHONY : zip
zip: $(BUILD_DIR)
	cd $(BUILD_DIR); touch README.html; \
	cmake -DCMAKE_BUILD_TYPE=Release -DZIP=1 ..

# debug target enables CuTest unit testing
.PHONY : debug
debug: $(BUILD_DIR)
	cd $(BUILD_DIR); \
	cmake -DTEST=1 DCMAKE_BUILD_TYPE=DEBUG ..

# analyze target enables use of clang's scan-build (if installed)
# will then need to run 'scan-build make' to compile and analyze
# 'scan-build -V make' will show the results graphically in your
# web browser
.PHONY : analyze
analyze: $(BUILD_DIR)
	cd $(BUILD_DIR); \
	scan-build cmake -DTEST=1 DCMAKE_BUILD_TYPE=DEBUG ..

.PHONY : map
map:
	cd $(BUILD_DIR); \
	../tools/enumsToPerl.pl ../Sources/libMultiMarkdown/include/libMultiMarkdown.h enumMap.txt;

# Clean out the build directory
.PHONY : clean
clean:
	rm -rf $(BUILD_DIR)/*

# Create build directory if it doesn't exist
$(BUILD_DIR): 
	-mkdir $(BUILD_DIR) 2>/dev/null
	-cd $(BUILD_DIR); rm -rf *
