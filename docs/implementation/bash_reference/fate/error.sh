function die() {
    # Kill entire process group for which 0 is the parent process,
    # aka main shell
    kill 0
}
