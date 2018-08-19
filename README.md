# Single Shot Active Learning
Matlab code of ''Single Shot Active Learning using Pseudo Annotators"

Reference: Yang, Yazhou, and Marco Loog. "Single Shot Active Learning using Pseudo Annotators." arXiv preprint arXiv:1805.06660 (2018).

## Installing

Download MVAL (https://github.com/YazhouTUD/MVAL) and add it to the path of Matlab.

## Usage

Just run "Main.m" to see how it works.

Choose "choice" from {1,2,3} depending on the used active learning algorithms:

choice:  choose the active learning algorithms

    1 -- Random sampling.
    
    2 -- ALRL_MaxE: our method with MaxE.
    
    3 -- ALRL_MVAL: our method with MVAL.

If you have any questions, please feel free to connect with me (yazhouy@gmail.com).


## Reference
If you are using this code, please consider citing the following reference:

Bibtex:

@article{yang2018singleshot,
  author    = {Yazhou Yang and
               Marco Loog},
  title     = {Single Shot Active Learning using Pseudo Annotators},
  journal   = {CoRR},
  volume    = {abs/1805.06660},
  year      = {2018},
  url       = {http://arxiv.org/abs/1805.06660},
  archivePrefix = {arXiv},
  eprint    = {1805.06660},
}
