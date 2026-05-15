// cofi-trigger: minimal Unix-socket client used by sway bindings to nudge
// the resident cofi daemon. Built from linux/CMakeLists.txt and installed
// next to the main bundle.
//
// Usage:
//   cofi-trigger            -> sends "show\n"  (open the launcher)
//   cofi-trigger --hide     -> sends "noop\n"  (probe — no-op if running)
//   cofi-trigger --quit     -> sends "quit\n"  (daemon exits cleanly)
//
// Exit codes:
//   0 - sent successfully
//   2 - daemon not reachable (socket file missing or connect refused)
//   1 - other error

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

static void resolve_socket_path(char *out, size_t out_size) {
    const char *runtime = getenv("XDG_RUNTIME_DIR");
    if (runtime && *runtime) {
        snprintf(out, out_size, "%s/cofi.sock", runtime);
        return;
    }
    const char *user = getenv("USER");
    snprintf(out, out_size, "/tmp/cofi-%s.sock", user ? user : "user");
}

int main(int argc, char *argv[]) {
    const char *cmd = "show\n";
    if (argc > 1) {
        if (strcmp(argv[1], "--hide") == 0) {
            cmd = "noop\n";
        } else if (strcmp(argv[1], "--quit") == 0) {
            cmd = "quit\n";
        } else if (strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-h") == 0) {
            fprintf(stderr,
                    "Usage: %s [--hide|--quit]\n"
                    "  (no args) send 'show' to the daemon\n"
                    "  --hide    probe the daemon without showing\n"
                    "  --quit    ask the daemon to exit cleanly\n",
                    argv[0]);
            return 0;
        }
    }

    char path[256];
    resolve_socket_path(path, sizeof(path));

    int fd = socket(AF_UNIX, SOCK_STREAM, 0);
    if (fd < 0) {
        perror("socket");
        return 1;
    }

    struct sockaddr_un addr;
    memset(&addr, 0, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, path, sizeof(addr.sun_path) - 1);

    if (connect(fd, (struct sockaddr *)&addr, sizeof(addr)) != 0) {
        if (errno == ENOENT || errno == ECONNREFUSED) {
            return 2;
        }
        perror("connect");
        return 1;
    }

    size_t len = strlen(cmd);
    ssize_t written = write(fd, cmd, len);
    if (written != (ssize_t)len) {
        perror("write");
        close(fd);
        return 1;
    }

    close(fd);
    return 0;
}
