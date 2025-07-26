#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import subprocess
import re
from pathlib import Path
from typing import List, Tuple, Dict


def find_example_files(directory: str) -> List[str]:
    """Find all example_N_facts.lp files in the given directory."""
    dir_path = Path(directory)
    if not dir_path.exists():
        print(f"Error: Directory '{directory}' does not exist.")
        sys.exit(1)
    
    example_files = sorted(dir_path.glob("example_*_facts.lp"))
    return [str(f) for f in example_files]


def run_clingo(facts_file: str, task_file: str) -> str:
    """Run clingo with the given facts and task files."""
    try:
        process = subprocess.Popen(
            ["clingo", facts_file, task_file, "0"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        stdout, stderr = process.communicate()
        
        print("Clingo stdout:")
        print(stdout)
        print("\nClingo stderr:")
        print(stderr)
            
        return stdout
    except FileNotFoundError:
        print("Error: clingo not found. Please ensure clingo is installed and in your PATH.")
        sys.exit(1)


def parse_out_cells(clingo_output: str) -> List[Tuple[int, int, str]]:
    """Parse out_cell predicates from clingo output."""
    cells = []
    
    # Look for lines containing out_cell predicates
    for line in clingo_output.split('\n'):
        # Match out_cell(x, y, color) predicates
        matches = re.findall(r'out_cell\((\d+),(\d+),(\w+)\)', line)
        for match in matches:
            x, y, color = match
            cells.append((int(x), int(y), color))
    
    return cells


def display_grid(cells: List[Tuple[int, int, str]]) -> None:
    """Display the cells as a grid in the terminal."""
    if not cells:
        print("No out_cell predicates found.")
        return
    
    # Find grid dimensions
    max_x = max(cell[0] for cell in cells)
    max_y = max(cell[1] for cell in cells)
    
    # Create color mapping for terminal display
    color_map = {
        'cyan': '\033[96m■\033[0m',
        'red': '\033[91m■\033[0m',
        'green': '\033[92m■\033[0m',
        'yellow': '\033[93m■\033[0m',
        'blue': '\033[94m■\033[0m',
        'magenta': '\033[95m■\033[0m',
        'white': '\033[97m■\033[0m',
        'black': '\033[90m■\033[0m'
    }
    
    # Build a dictionary for quick lookup
    cell_dict = {(x, y): color for x, y, color in cells}
    
    # Display grid
    print("\nGrid Output:")
    print("  ", end="")
    for x in range(1, max_x + 1):
        print(f"{x} ", end="")
    print()
    
    for y in range(1, max_y + 1):
        print(f"{y} ", end="")
        for x in range(1, max_x + 1):
            if (x, y) in cell_dict:
                color = cell_dict[(x, y)]
                print(color_map.get(color, '?'), end=" ")
            else:
                print(". ", end="")
        print()
    
    # Display legend
    used_colors = set(color for _, _, color in cells)
    if used_colors:
        print("\nLegend:")
        for color in sorted(used_colors):
            print(f"  {color_map.get(color, '?')} = {color}")


def main():
    if len(sys.argv) != 2:
        print("Usage: python task_runner.py <directory>")
        sys.exit(1)
    
    directory = sys.argv[1]
    task_file = os.path.join(directory, "task.lp")
    
    if not os.path.exists(task_file):
        print(f"Error: task.lp not found in directory '{directory}'")
        sys.exit(1)
    
    example_files = find_example_files(directory)
    
    if not example_files:
        print(f"No example_*_facts.lp files found in directory '{directory}'")
        sys.exit(1)
    
    for facts_file in example_files:
        print(f"\n{'='*60}")
        print(f"Processing: {os.path.basename(facts_file)}")
        print(f"{'='*60}")
        
        clingo_output = run_clingo(facts_file, task_file)
        
        # Check if solution was found
        if "UNSATISFIABLE" in clingo_output:
            print("No solution found (UNSATISFIABLE)")
            continue
        elif "SATISFIABLE" not in clingo_output:
            print("Warning: Could not determine if solution is satisfiable")
        
        cells = parse_out_cells(clingo_output)
        display_grid(cells)


if __name__ == "__main__":
    main()