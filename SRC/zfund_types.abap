TYPES: BEGIN OF ty_allocation,
         department TYPE char20,
         sector     TYPE char20,
         fiscal_year TYPE gjahr,
         allocated  TYPE p DECIMALS 2,
       END OF ty_allocation.

TYPES: BEGIN OF ty_utilization,
         department TYPE char20,
         posting_date TYPE sy-datum,
         utilized   TYPE p DECIMALS 2,
       END OF ty_utilization.

TYPES: BEGIN OF ty_result,
         department TYPE char20,
         allocated  TYPE p DECIMALS 2,
         utilized   TYPE p DECIMALS 2,
         percentage TYPE p DECIMALS 2,
         risk       TYPE char10,
         icon       TYPE icon_d,
       END OF ty_result.

DATA: gt_alloc  TYPE STANDARD TABLE OF ty_allocation,
      gt_util   TYPE STANDARD TABLE OF ty_utilization,
      gt_result TYPE STANDARD TABLE OF ty_result.
