REPORT zfund_leakage_report.

INCLUDE zfund_types.
INCLUDE zfund_rules.
INCLUDE <icon>.

PARAMETERS: p_year TYPE gjahr OBLIGATORY,
            p_high TYPE p DECIMALS 2 DEFAULT '100',
            p_med  TYPE p DECIMALS 2 DEFAULT '70'.

START-OF-SELECTION.

  PERFORM get_data.
  PERFORM process_data.
  PERFORM display_alv.


FORM get_data.

  CLEAR: gt_alloc, gt_util.

  gt_alloc = VALUE #(
    ( department = 'HEALTH'    sector = 'PUBLIC' fiscal_year = p_year allocated = 100000 )
    ( department = 'EDUCATION' sector = 'PUBLIC' fiscal_year = p_year allocated = 150000 )
    ( department = 'DEFENCE'   sector = 'PUBLIC' fiscal_year = p_year allocated = 200000 )
  ).

  gt_util = VALUE #(
    ( department = 'HEALTH'    posting_date = sy-datum utilized = 120000 )
    ( department = 'EDUCATION' posting_date = sy-datum utilized = 90000 )
    ( department = 'DEFENCE'   posting_date = sy-datum utilized = 50000 )
  ).

ENDFORM.


FORM process_data.

  DATA: ls_result TYPE ty_result,
        lv_total_alloc TYPE p DECIMALS 2 VALUE 0,
        lv_total_util  TYPE p DECIMALS 2 VALUE 0.

  LOOP AT gt_alloc INTO DATA(ls_alloc).

    CLEAR ls_result.
    ls_result-department = ls_alloc-department.
    ls_result-allocated  = ls_alloc-allocated.

    READ TABLE gt_util INTO DATA(ls_util)
      WITH KEY department = ls_alloc-department.

    IF sy-subrc = 0.
      ls_result-utilized = ls_util-utilized.
    ENDIF.

    PERFORM calculate_percentage
      USING ls_result-allocated
            ls_result-utilized
      CHANGING ls_result-percentage.

    PERFORM classify_risk
      USING ls_result-percentage
            p_high
            p_med
      CHANGING ls_result-risk
               ls_result-icon.

    APPEND ls_result TO gt_result.

    lv_total_alloc += ls_result-allocated.
    lv_total_util  += ls_result-utilized.

  ENDLOOP.

  WRITE: / 'Total Allocation:', lv_total_alloc.
  WRITE: / 'Total Utilization:', lv_total_util.

ENDFORM.


FORM display_alv.

  DATA: lo_alv TYPE REF TO cl_salv_table.

  cl_salv_table=>factory(
    IMPORTING r_salv_table = lo_alv
    CHANGING  t_table      = gt_result ).

  lo_alv->get_columns( )->get_column( 'ICON' )->set_icon( abap_true ).

  lo_alv->display( ).

ENDFORM.
