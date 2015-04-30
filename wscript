#!/usr/bin/env python

import os

top='.'

def configure(cfg):
    cfg.load('tex')
    pass


def build(bld):

    # convention calls for all top-level .tex files to be mains
    for tex in bld.path.ant_glob('*.tex'):
        bld(features='tex',
            type='pdflatex',
            source = tex,
            outs = 'pdf',
            )
        bld.install_files('${PREFIX}',tex.change_ext('.pdf', '.tex'))
    return


