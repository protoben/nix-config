Hash Function Properties vs. Quantum Adversaries
================================================


Property relationships
----------------------

* *P→ Q:* If no quantum aversary can break property *P(f)*, then no quantum
          adversary can break property *Q(f)*.
* *P↛ Q:* There exists a function *f* s.t. no quantum adversary can break
          *P(f)*, but some adversary *A* can break *Q(f)*.
* *P↣ Q:* Like *P→ Q*, but follows from transitivity (for some property *R*,
          *P→ Q* and *P→ Q*).
* *P⤔ Q:* Like *P↛ Q*, but follows from transitivity (for some property *R*,
          *P↛ R* and *Q→ R*).
* *P⇒ Q:* Like *P→ Q*, but the quantum proof follows from the classical one,
          since the reduction has a "classical interface".
* *P⇏ Q:* Like *P↛ Q*, but the quantum proof follows from the classical one
          because the reduction in the separation has a "classical interface".
* ?:      Relationship unknown or unproven.

|         |  Sec  | aSec  | eSec  |  Pre  | aPre  | ePre  | Coll  | CLAPS |
|:-------:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
|**Sec**  |   -   |   ⇏   |   ⇏   |   ⇏   |   ⇏   |   ⇏   |   ⇏   |   ⤔   |
|**aSec** |   ⇒   |   -   |   ⇏   |   ⇏   |   ⇒   |   ⇏   |   ⇏   |   ⤔   |
|**eSec** |   ⇒   |   ⇏   |   -   |   ⇏   |   ⇏   |   ⇒   |   ⇏   |   ⤔   |
|**Pre**  |   ⇏   |   ⇏   |   ⇏   |   -   |   ⇏   |   ⇏   |   ⇏   |   ⤔   |
|**aPre** |   ⇏   |   ⇏   |   ⇏   |   ⇒   |   -   |   ⇏   |   ⇏   |   ⤔   |
|**ePre** |   ⇏   |   ⇏   |   ⇏   |   ⇒   |   ⇏   |   -   |   ⇏   |   ⤔   |
|**Coll** |   ⇒   |   ⇏   |   ⇒   |   ⇒   |   ⇏   |   ⇏   |   -   |   ?   |
|**CLAPS**|   ↣   |   ↛   |   ↣   |   ↣   |   ↛   |   ↛   |   →   |   -   |


Iterated hash property preservation
-----------------------------------

* ✓ : For any compression function *H*, s.t. no quantum adversary can break
      *P(H)*, no quantum adversary can break *P(IH)*, either.
* ✗ : There exists a compression function *H*, s.t. no quantum adversary can
      break *P(H)*, but some adversary *A* can break *P(IH)*.
* ✔ : Like ✓ , but the quantum proof follows from the classical one, since
      the reduction has a "classical interface".

|         |  Sec  | aSec  | eSec  |  Pre  | aPre  | ePre  | Coll  | CLAPS |
|:-------:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
|**ROX**  |       |       |       |       |       |       |       |       |
|**MD**   |       |       |       |       |       |       |       |       |
|**XLH**  |       |       |       |       |       |       |       |       |
