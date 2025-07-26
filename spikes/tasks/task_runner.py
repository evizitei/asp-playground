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
        
        # print("Clingo stdout:")
        # print(stdout)
        # print("\nClingo stderr:")
        # print(stderr)
            
        return stdout
    except FileNotFoundError:
        print("Error: clingo not found. Please ensure clingo is installed and in your PATH.")
        sys.exit(1)


def parse_cells(clingo_output: str, predicate_name: str) -> List[Tuple[int, int, str]]:
    """Parse cell predicates from clingo output."""
    cells = []
    
    # Look for lines containing cell predicates
    for line in clingo_output.split('\n'):
        # Match cell(x, y, color) predicates
        pattern = rf'{predicate_name}\((\d+),(\d+),(\w+)\)'
        matches = re.findall(pattern, line)
        for match in matches:
            x, y, color = match
            cells.append((int(x), int(y), color))
    
    return cells


def display_grid(cells: List[Tuple[int, int, str]], grid_title: str = "Grid") -> None:
    """Display the cells as a grid in the terminal."""
    if not cells:
        print(f"No cells found for {grid_title}.")
        return
    
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
    print(f"\n{grid_title}:")
    print("  ", end="")
    for x in range(11):  # 0 to 10
        print(f"{x} ", end="")
    print()
    
    for y in range(11):  # 0 to 10
        print(f"{y:2}", end=" ")  # Right-align single digits
        for x in range(11):
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
        
        # Parse and display input grid
        input_cells = parse_cells(clingo_output, "in_cell")
        if input_cells:
            display_grid(input_cells, "INPUT Grid")
        
        # Parse and display output grid
        output_cells = parse_cells(clingo_output, "out_cell")
        display_grid(output_cells, "OUTPUT Grid")


if __name__ == "__main__":
    main()