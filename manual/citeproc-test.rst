==================
The CSL Test Suite
==================
~~~~~~~~~~~~~~~~~~
Developer's Manual
~~~~~~~~~~~~~~~~~~

.. class:: fixed

   `citationstyles.org`__

__ http://citationstyles.org/



.. class:: info-version

   version 1.00##a2##

.. class:: info-date

   =D=25 May 2010=D=

.. class:: contributors

   Author of this manual
       * Frank G. Bennett, Jr.

.. |link| image:: link.png

========

.. contents:: Table of Contents

========

############
Introduction
############

CSL ships with a large bundle of test data for use in the
development and maintenance of CSL processors.  The tests begin as 
individual human-friendly fixtures written in a special format, shown 
in the sample file immediately below.  Tests are prepared for use by 
grinding them into a machine-friendly form (JSON).  The JSON form
of tests can be run against processors in a test-bed environment
with processor-specific tools prepared for that purpose.


###################
Preparing the tests
###################

Tests can be validated and prepared (or "compiled") using 
the ``./processor.py`` script in the root
directory of the archive.  The script accepts the following
options:

``--help``: 
     List the script options with a brief description
     of each and exit
``--cranky``
     validate style code for testing against the
     CSL schema using the ``jing`` XML tool.
``--grind``
     Force grinding of human-readable test code into machine-
     readable form.
``--verbose``      
     Display test names during processing.


##############
Fixture layout
##############

The human-readable version of each test fixture is composed in
the format below.  The five sections ``MODE``,
``RESULT``, ``CSL`` and ``INPUT`` are required, and may be 
arranged in any order within the fixture file.  As the
sample below illustrates, text outside of the section
delimiters is ignored.  The sample file below shows the
layout of a typical fixture.  See the explanations of
the individual sections further below for information on
the usage of each.

.. class:: clothesline

   ..

      .. admonition:: Hint
   
         Four additional sections are available for special
         purposes.  The optional sections 
         ``BIBENTRIES``, ``BIBSECTION``, ``CITATIONS`` and ``CITATION-ITEMS``
         are also explained below.

.. sourcecode:: text

   >>===== MODE =====>>
   citation
   <<===== MODE =====<<
   
   # Everything between the section blocks is
   # ignored.  Comment markup can be used for 
   # clarity, but it is not required.

      
   >>===== RESULT =====>>
   John Doe
   <<===== RESULT =====<<
   
   
   >>===== CSL =====>>
   <style 
         xmlns="http://purl.org/net/xbiblio/csl"
         class="in-text"
         version="1.0">
     <info>
       <id />
       <title />
       <updated>2009-08-10T04:49:00+09:00</updated>
     </info>
     <citation>
       <layout>
         <names variable="author">
           <name />
         </names>
       </layout>
     </citation>
   </style>
   <<===== CSL =====<<
   
   
   >>===== INPUT =====>>
   [
      {
         "id":"ID-1",
         "type": "book",
         "author": [
            { "name":"Doe, John" }
         ],
         "issued": {
            "date-parts": [
               [
                  "1965", 
                  "6", 
                  "1"
               ]
            ]
         }
      }
   ]
   <<===== INPUT =====<<


^^^^^^^^^^^^^^^^^
Required sections
^^^^^^^^^^^^^^^^^

The following four sections (``MODE``, ``CSL``, ``INPUT``, ``RESULT``)
are required in all test fixtures.

!!!!
MODE
!!!!

A single string tells whether to test ``citation`` or ``bibliography``
output.  In the former case, the test will be performed using 
the ``makeCitationCluster()`` command if a ``CITATION-ITEMS`` area is 
included in the test fixture, or if neither that nor a ``CITATIONS`` 
area is included.  If a ``CITATIONS`` area is included,
``citation`` mode uses the ``processCitationCluster`` command.

In the case of ``bibliography`` mode, the bibliography generation
command should be used, with output possibly filtered by the conditions
specified in a ``BIBSECTION`` area:

.. sourcecode:: text

   >>===== MODE =====>>
   citation
   <<===== MODE =====<<

!!!
CSL
!!!

The code to be used in the test must be valid
as a complete, if minimal, CSL style:

.. sourcecode:: text

   >>===== CSL =====>>
   <style 
         xmlns="http://purl.org/net/xbiblio/csl"
         class="in-text"
         version="1.0">
     <info>
       <id />
       <title />
       <updated>2009-08-10T04:49:00+09:00</updated>
     </info>
     <citation
       et-al-min="3"
       et-al-use-first="1">
       <layout delimiter="; ">
         <group delimiter=" ">
           <names>
             <name form="short"/>
           </names>
           <date 
               variable="issued" 
               date-parts="year" 
               form="text"
               prefix="("
               suffix=")"/>
         </group>
       </layout>
     </citation>
     <bibliography>
       <layout>
         <group delimiter=" ">
           <names variable="author">
             <name delimiter=" " initialize-with="."/>
           </names>
           <date 
               variable="issued" 
               date-parts="year" 
               form="text"
               prefix="("
               suffix=")"/>
         </group>
       </layout>
     </bibliography>
   </style>
   <<===== CSL =====<<


!!!!!
INPUT
!!!!!

The ``INPUT`` section provides the item data to be registered
in the processor.  In a simple test fixture that contains
none of the optional areas ``BIBENTRIES``, ``BIBSECTION`` ``CITATIONS``
or ``CITATION-ITEMS``,
a citation or bibligraphy is requested for *all* of the
items in the ``INPUT`` section (where one of those two
optional sections is included, the testing behavior is slightly
different; see the discussion of the relevant sections below
for details):

.. sourcecode:: text

   >>===== INPUT =====>>
   [
    {
      "id":"ID-1",
      "author": [
           { "name":"Noakes, John" },
           { "name":"Doe, John" },
           { "name":"Roe, Jane" }
      ],
      "issued": {
         "date-parts": [
            [
               2005
            ]
         ]
      }
    },
    {
      "id":"ID-2",
      "author": [
           { "name":"Stoakes, Richard" }
      ],
      "issued": {
         "date-parts": [
            [
               1898
            ]
         ]
      }
    }
   ]
   <<===== INPUT =====<<

!!!!!!
RESULT
!!!!!!

A string to compare with the citation or bibliography output
received from the processor.

.. sourcecode:: text

   >>===== RESULT =====>>
   (Noakes, et al. 2005; Stoakes 1898)
   <<===== RESULT =====<<

Note that in ``bibliography`` mode, the HTML string output 
used for testing will be affixed with a standard set of 
wrapper tags, which must be written into the result string
used for comparison:

.. sourcecode:: text

   >>===== RESULT =====>>
   <div class="csl-bib-body">
     <div class="csl-entry">J. Noakes, J. Doe, J. Roe (2005)</div>
     <div class="csl-entry">R. Stoakes (1898)</div>
   </div>
   <<===== RESULT =====<<


^^^^^^^^^^^^^^^^^
Optional sections
^^^^^^^^^^^^^^^^^

Four optional sections are available for use in a fixture
to exercise special aspects of processor behavior.

!!!!!!!!!!
BIBENTRIES
!!!!!!!!!!

The ``citeproc-js`` processor maintains a persistent internal registry
of citation data, and permits the addition, deletion and rearrangement
of registered items.  The behavior of the processor across a series of
update transactions can be tested by including ``BIBENTRIES`` section.
When included, the section should consist of a two-tier list,
consisting of discrete lists of IDs, which must correspond to items
registered in the ``INPUT`` section:

.. class:: clothesline

   ..

      .. admonition:: Hint

         The test of output will be run after first updating the
         processor's internal registry to reflect each of the
         requested citation sets, and should correctly reflect the
         last in the series.

.. sourcecode:: text

   >>===== BIBENTRIES =====>>
   [
     [
       "ITEM-1",
       "ITEM-2",
       "ITEM-3",
       "ITEM-4",
       "ITEM-5"
     ],
     [
       "ITEM-1",
       "ITEM-4",
       "ITEM-5"
     ]
   ]
   <<===== BIBENTRIES =====<<

!!!!!!!!!!
BIBSECTION
!!!!!!!!!!

When ``bibliography`` mode is used, a ``BIBSECTION`` area
can be used to limit the output of the bibligraphy.  The
filtering logic is described below, but first an example
of the way it looks in a test fixture:


.. sourcecode:: text

   >>===== BIBSECTION =====>>
   {
      "include" : [
         {
            "field" : "categories",
            "value" : "classical"
         }
      ],
      "quash" : [
         {
            "field" : "type",
            "value" : "manuscript"
         },
         {
            "field" : "issued",
            "value" : ""
         }
      ]
   }
   <<===== BIBSECTION =====<<


Filtering parameters for bibliography output are specified in a JSON object
that may contain
*one of* the objects ``select``, ``include`` or ``exclude``, and
optionally an additional  ``quash`` object.  Each of these four objects
is an array containing one or more objects with ``field`` and ``value``
attributes, each with a simple string value (see the examples below).
The matching behavior for each of the four object types, with accompanying
input examples, is as follows:

``select``
   For each item in the bibliography, try every match object in the array against
   the item, and include the item if, and only if, *all* of the objects match.

.. admonition:: Hint

   The target field in the data items registered in the processor
   may either be a string or an array.  In the latter case,
   an array containing a value identical to the
   relevant value is treated as a match.

.. sourcecode:: js

   var myarg = {
      "select" : [
         {
            "field" : "type",
            "value" : "book"
         },
         {  "field" : "categories",
             "value" : "1990s"
         }
      ]
   }

   var mybib = cp.makeBibliography(myarg);

``include``
   Try every match object in the array against the item, and include the
   item if *any* of the objects match.

.. sourcecode:: js

   var myarg = {
      "include" : [
         {
            "field" : "type",
            "value" : "book"
         }
      ]
   }

   var mybib = cp.makeBibliography(myarg);

``exclude``
   Include the item if *none* of the objects match.

.. sourcecode:: js

   var myarg = {
      "exclude" : [
         {
            "field" : "type",
            "value" : "legal_case"
         },
         {
            "field" : "type",
            "value" : "legislation"
         }
      ]
   }

   var mybib = cp.makeBibliography(myarg);

``quash``
   Regardless of the result from ``select``, ``include`` or ``exclude``,
   skip the item if *all* of the objects match.


.. admonition:: Hint

   An empty string given as the field value will match items
   for which that field is missing or has a nil value.

.. sourcecode:: js

   var myarg = {
      "include" : [
         {
            "field" : "categories",
            "value" : "classical"
         }
      ],
      "quash" : [
         {
            "field" : "type",
            "value" : "manuscript"
         },
         {
            "field" : "issued",
            "value" : ""
         }
      ]
   }

   var mybib = cp.makeBibliography(myarg);



!!!!!!!!!!!!!!
CITATION-ITEMS
!!!!!!!!!!!!!!

When testing in ``citation`` mode, the data items to be
processed are ordinarily rendered as a single citation.
To test operations that depend upon or may be affected
by the internal state of the processor across a session,
either a ``CITATION-ITEMS`` or a ``CITATIONS`` section
may be included in the test fixture (only one may be used
in a single test fixture).

``CITATION-ITEMS`` is the simpler of the two, used in
most of the standard processor formatting test fixtures.
The data input in this area should consist of a list array
of cite data, where each cite consists of a Javascript object
containing, at least, item ID.
A single citation is composed of a list of cites, and
the full entry consists of a list of such citations:

.. sourcecode:: text

   >>===== CITATION-ITEMS =====>>
   [
     [
       {"id": "ITEM-1"}
     ],
     [
       {"id": "ITEM-2", "label": "page", "locator": "23"},
       {"id":"ITEM-3"}
     ]
   ]
   <<===== CITATION-ITEMS =====<<

!!!!!!!!!
CITATIONS
!!!!!!!!!

A ``CITATIONS`` area can be used (instead of ``CITATION-ITEMS``)
to mimic a series of interactions with a word processor plugin.
In this case, the area should contain a list array of citation
data objects with explict ``citationID`` values and ID list values
for subsequent invocations of the ``processCitationCluster()`` command,
like the following:

.. sourcecode:: text

   >>===== CITATIONS =====>>
   [
      [
         {
            "citationID": "CITATION-1",
            "citationItems": [
               {
                  "id": "ITEM-1"
               }
            ], 
            "properties": {
               "noteIndex": 1
            }
         },
         [],
         []
      ],
      [
         {
            "citationID": "CITATION-2",
            "citationItems": [
               {
                  "id": "ITEM-2",
                  "locator": 15
               },
               {
                  "id": "ITEM-3"
               }
            ], 
            "properties": {
               "noteIndex": 2
            }
         },
         [
           [
             "CITATION-1",
             1
           ]
         ],
         []
      ]
   ]
   <<===== CITATIONS =====<<

