"""BLUE-TANUKI reference adapter package.

Runtime-specific mapping lives here and must not leak into Shell Core.
"""

from .adapter import BlueTanukiAdapter

__all__ = ["BlueTanukiAdapter"]
