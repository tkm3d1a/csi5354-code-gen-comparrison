#!/bin/bash

#==============================================================================
# Repository Analysis Script
# Analyzes LOC, imports, annotations, dependencies, and test coverage metrics
#==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Target directory (default to current directory)
TARGET_DIR="${1:-.}"

# Validate directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}Error: Directory '$TARGET_DIR' does not exist.${NC}"
    exit 1
fi

cd "$TARGET_DIR"

echo -e "${BOLD}${BLUE}"
echo "╔══════════════════════════════════════════════════════════════════════╗"
echo "║                    REPOSITORY ANALYSIS REPORT                        ║"
echo "╚══════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo -e "${CYAN}Analyzing:${NC} $(pwd)"
echo -e "${CYAN}Timestamp:${NC} $(date)"
echo ""

#==============================================================================
# SECTION 1: Lines of Code (cloc)
#==============================================================================
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  LINES OF CODE ANALYSIS${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if command -v cloc &> /dev/null; then
    cloc . \
        --exclude-dir=.idea,.git,target,.settings,.vscode,node_modules,logs,build,out,.gradle \
        --exclude-ext=iml,log,class \
        --not-match-f='(\.classpath|\.project)$' \
        --quiet
    
    # Save detailed report
    cloc . \
        --exclude-dir=.idea,.git,target,.settings,.vscode,node_modules,logs,build,out,.gradle \
        --exclude-ext=iml,log,class \
        --by-file \
        --quiet \
        --report-file=cloc-detailed-report.txt 2>/dev/null || true
    
    echo -e "\n${CYAN}Detailed file report saved to: cloc-detailed-report.txt${NC}"
else
    echo -e "${RED}Warning: cloc not installed. Skipping LOC analysis.${NC}"
    echo "Install with: sudo apt install cloc (or brew install cloc)"
fi

#==============================================================================
# SECTION 2: Java File Statistics
#==============================================================================
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  JAVA FILE STATISTICS${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Count Java files
TOTAL_JAVA_FILES=$(find . -name "*.java" -not -path "*/target/*" -not -path "*/.git/*" 2>/dev/null | wc -l)

echo -e "${CYAN}Total Java Files:${NC}      $TOTAL_JAVA_FILES"

#==============================================================================
# SECTION 3: Import Analysis
#==============================================================================
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  IMPORT ANALYSIS${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

TOTAL_IMPORTS=$(find . -name "*.java" -not -path "*/target/*" -exec grep -h "^import " {} + 2>/dev/null | wc -l)
UNIQUE_IMPORTS=$(find . -name "*.java" -not -path "*/target/*" -exec grep -h "^import " {} + 2>/dev/null | sort -u | wc -l)
STATIC_IMPORTS=$(find . -name "*.java" -not -path "*/target/*" -exec grep -h "^import static " {} + 2>/dev/null | wc -l)

echo -e "${CYAN}Total Import Statements:${NC}   $TOTAL_IMPORTS"
echo -e "${CYAN}Unique Imports:${NC}            $UNIQUE_IMPORTS"
echo -e "${CYAN}Static Imports:${NC}            $STATIC_IMPORTS"

echo ""
echo -e "${YELLOW}Top 10 Most Used Imports:${NC}"
find . -name "*.java" -not -path "*/target/*" -exec grep -h "^import " {} + 2>/dev/null \
    | sed 's/import //' | sed 's/;//' \
    | sort | uniq -c | sort -rn | head -10 \
    | while read count import; do
        printf "  %5d  %s\n" "$count" "$import"
    done

#==============================================================================
# SECTION 4: Annotation Analysis
#==============================================================================
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  ANNOTATION ANALYSIS${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

TOTAL_ANNOTATIONS=$(find . -name "*.java" -not -path "*/target/*" -exec grep -hE "^\s*@\w+" {} + 2>/dev/null | wc -l)
echo -e "${CYAN}Total Annotation Lines:${NC}    $TOTAL_ANNOTATIONS"

echo ""
echo -e "${YELLOW}Top 15 Annotations Used:${NC}"
find . -name "*.java" -not -path "*/target/*" -exec grep -ohE "^\s*@\w+" {} + 2>/dev/null \
    | sed 's/^[[:space:]]*//' \
    | sort | uniq -c | sort -rn | head -15 \
    | while read count annotation; do
        printf "  %5d  %s\n" "$count" "$annotation"
    done

#==============================================================================
# SECTION 5: Maven Dependencies (pom.xml)
#==============================================================================
echo ""
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}${GREEN}  MAVEN DEPENDENCY ANALYSIS${NC}"
echo -e "${BOLD}${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if [[ -f "pom.xml" ]]; then
    # Count dependencies
    TOTAL_DEPS=$(grep -c "<dependency>" pom.xml 2>/dev/null || echo "0")
    
    echo -e "${CYAN}Total Dependencies:${NC}        $TOTAL_DEPS"
    
    # Count plugins
    TOTAL_PLUGINS=$(grep -c "<plugin>" pom.xml 2>/dev/null || echo "0")
    echo -e "${CYAN}Maven Plugins:${NC}             $TOTAL_PLUGINS"
    
    # List dependencies
    echo ""
    echo -e "${YELLOW}Dependencies List:${NC}"
    grep -A2 "<dependency>" pom.xml 2>/dev/null \
        | grep -E "<(groupId|artifactId)>" \
        | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' \
        | paste - - \
        | while read groupId artifactId; do
            echo "  $groupId:$artifactId"
        done
else
    echo -e "${RED}No pom.xml found in root directory.${NC}"
fi

#==============================================================================
# SUMMARY
#==============================================================================
echo ""
echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║                         ANALYSIS COMPLETE                            ║${NC}"
echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Reports generated:${NC}"
echo "  - cloc-detailed-report.txt (if cloc available)"
echo ""
