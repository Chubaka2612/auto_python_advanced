"""
utils/logger.py
---------------
Provides a pre-configured logger for every module.

Usage in any file:
    from utils.logger import get_logger
    log = get_logger(__name__)
    log.info("Navigating to login page")

Java analogy: Like Log4j / SLF4J — one factory, consistent format everywhere.
"""
import logging


def get_logger(name: str) -> logging.Logger:
    """Return a logger with consistent formatting.
    Pass __name__ so log lines show the module they came from.
    """
    logger = logging.getLogger(name)

    if not logger.handlers:                        # avoid duplicate handlers on re-import
        handler = logging.StreamHandler()
        formatter = logging.Formatter(
            fmt="%(asctime)s [%(levelname)-8s] %(name)s: %(message)s",
            datefmt="%H:%M:%S",
        )
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        logger.setLevel(logging.DEBUG)

    return logger
