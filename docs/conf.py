import os
import sys
import time
import re
import pkgutil
import string
import f5_sphinx_theme
# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

# REQUIRED: Your class/lab name
classname = "F5 Distributed Cloud"

sys.path.insert(0, os.path.abspath("."))

year = time.strftime("%Y")
eventname = "BIG-IP to Distributed Cloud Migration FAQ %s" % (year)

project = 'BIG-IP to XC'
copyright = '2024, Michael Coleman'
author = 'Michael Coleman'
release = '2024'

# The master toctree document.
master_doc = "index"

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

templates_path = ['_templates']
exclude_patterns = []

extensions = [
    "sphinx.ext.todo",
    "sphinx.ext.extlinks",
    "sphinx.ext.graphviz",
    "sphinxcontrib.nwdiag",
    "sphinx_copybutton",
    "sphinxcontrib.blockdiag",
]

graphviz_output_format = "svg"
graphviz_font = "DejaVu Sans:style=Book"
graphviz_dot_args = [
    "-Gfontname='%s'" % graphviz_font,
    "-Nfontname='%s'" % graphviz_font,
    "-Efontname='%s'" % graphviz_font,
]

diag_fontpath = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
diag_html_image_format = "SVG"
diag_latex_image_format = "PNG"
diag_antialias = False

blockdiag_fontpath = nwdiag_fontpath = diag_fontpath
blockdiag_html_image_format = nwdiag_html_image_format = diag_html_image_format
blockdiag_latex_image_format = nwdiag_latex_image_format = diag_latex_image_format
blockdiag_antialias = nwdiag_antialias = diag_antialias

eggs_loader = pkgutil.find_loader("sphinxcontrib.spelling")
found = eggs_loader is not None

if found:
    extensions += ["sphinxcontrib.spelling"]
    spelling_lang = "en_US"
    spelling_word_list_filename = "../wordlist"
    spelling_show_suggestions = True
    spelling_ignore_pypi_package_names = False
    spelling_ignore_wiki_words = True
    spelling_ignore_acronyms = True
    spelling_ignore_python_builtins = True
    spelling_ignore_importable_modules = True
    spelling_filters = []

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

# html4_writer = True
#html_theme = "f5_sphinx_theme"
html_theme = "nature"
html_theme_path = f5_sphinx_theme.get_html_theme_path()
html_sidebars = {"**": ["searchbox.html", "localtoc.html", "globaltoc.html"]}
html_theme_options = {
    "site_name": "Community Training Classes & Labs",
    "next_prev_link": True
}
html_codeblock_linenos_style = 'table'
#html_context = {"github_url": github_repo}

html_last_updated_fmt = "%Y-%m-%d %H:%M:%S"

#extlinks = {"issues": (("%s/issues/%%s" % github_repo), "issue ")}
html_static_path = ['_static']

cleanname = re.sub("\\W+", "", classname)

# Output file base name for HTML help builder.
htmlhelp_basename = cleanname + "doc"

# -- Options for LaTeX output ---------------------------------------------

front_cover_image = "front_cover"
back_cover_image = "back_cover"

front_cover_image_path = os.path.join("_static", front_cover_image + ".png")
back_cover_image_path = os.path.join("_static", back_cover_image + ".png")

latex_additional_files = [front_cover_image_path, back_cover_image_path]

template = string.Template(open("preamble.tex").read())

latex_contents = r"""
\frontcoverpage
\contentspage
"""

backcover_latex_contents = r"""
\backcoverpage
"""

latex_elements = {
    "papersize": "letterpaper",
    "pointsize": "10pt",
    "fncychap": r"\usepackage[Bjornstrup]{fncychap}",
    "preamble": template.substitute(
        eventname=eventname,
        project=project,
        author=author,
        frontcoverimage=front_cover_image,
        backcoverimage=back_cover_image,
    ),
    "tableofcontents": latex_contents,
    "printindex": backcover_latex_contents,
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (
        master_doc,
        "%s.tex" % cleanname,
        "%s Documentation" % classname,
        "F5 Networks, Inc.",
        "manual",
        True,
    ),
]

# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, cleanname.lower(), "%s Documentation" % classname, [author], 1)
]


# -- Options for Texinfo output -------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (
        master_doc,
        classname,
        "%s Documentation" % classname,
        author,
        classname,
        classname,
        "Training",
    ),
]