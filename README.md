zipkin-infrastructure
=====================

All components needed to run Zipkin in nice little Docker containers (Zipkin, FB-Scribe, Cassandra, Zookeeper)


We try to place as many installation commands into Docker files, to ease the build process:
 * Each build step is frozen as an intermediate container
 * Errors during build don`t require rerunning it completely
 * Testing new install instaructions start from a partly build process and thus run faster
 
