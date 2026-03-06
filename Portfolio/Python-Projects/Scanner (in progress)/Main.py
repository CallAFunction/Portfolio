import argparse
from scanner.port_scanner import scan_ports
from scanner.host_discovery import discover_hosts

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["port", "discover"])
    parser.add_argument("--target")

    args = parser.parse_args()

    if args.mode == "port":
        scan_ports(args.target)
    elif args.mode == "discover":
        discover_hosts(args.target)

if __name__ == "__main__":
    main()