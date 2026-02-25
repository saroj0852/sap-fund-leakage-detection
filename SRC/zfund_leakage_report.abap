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

*---------------------------------------------------------------------*
FORM get_data.

  DATA: ls_alloc TYPE ty_allocation,
        ls_util  TYPE ty_utilization.

  CLEAR gt_alloc.
  CLEAR gt_util.

  ls_alloc-department = 'HEALTH'.
  ls_alloc-sector = 'PUBLIC'.
  ls_alloc-fiscal_year = p_year.
  ls_alloc-allocated = '100000'.
  APPEND ls_alloc TO gt_alloc.

  ls_alloc-department = 'EDUCATION'.
  ls_alloc-sector = 'PUBLIC'.
  ls_alloc-fiscal_year = p_year.
  ls_alloc-allocated = '150000'.
  APPEND ls_alloc TO gt_alloc.

  ls_alloc-department = 'DEFENCE'.
  ls_alloc-sector = 'PUBLIC'.
  ls_alloc-fiscal_year = p_year.
  ls_alloc-allocated = '200000'.
  APPEND ls_alloc TO gt_alloc.

  ls_util-department = 'HEALTH'.
  ls_util-posting_date = sy-datum.
  ls_util-utilized = '120000'.
  APPEND ls_util TO gt_util.

  ls_util-department = 'EDUCATION'.
  ls_util-posting_date = sy-datum.
  ls_util-utilized = '90000'.
  APPEND ls_util TO gt_util.

  ls_util-department = 'DEFENCE'.
  ls_util-posting_date = sy-datum.
  ls_util-utilized = '50000'.
  APPEND ls_util TO gt_util.

ENDFORM.

*---------------------------------------------------------------------*
FORM process_data.

  DATA: ls_result TYPE ty_result,
        ls_alloc  TYPE ty_allocation,
        ls_util   TYPE ty_utilization,
        lv_total_alloc TYPE p DECIMALS 2,
        lv_total_util  TYPE p DECIMALS 2.

  LOOP AT gt_alloc INTO ls_alloc.

    CLEAR ls_result.
    ls_result-department = ls_alloc-department.
    ls_result-allocated  = ls_alloc-allocated.

    READ TABLE gt_util INTO ls_util
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

    lv_total_alloc = lv_total_alloc + ls_result-allocated.
    lv_total_util  = lv_total_util  + ls_result-utilized.

  ENDLOOP.

  WRITE: / 'Total Allocation:', lv_total_alloc.
  WRITE: / 'Total Utilization:', lv_total_util.

ENDFORM.

*---------------------------------------------------------------------*
FORM display_alv.

  DATA: lo_alv TYPE REF TO cl_salv_table,
        lo_cols TYPE REF TO cl_salv_columns_table,
        lo_col  TYPE REF TO cl_salv_column.

  cl_salv_table=>factory(
      IMPORTING r_salv_table = lo_alv
      CHANGING  t_table      = gt_result ).

  lo_cols = lo_alv->get_columns( ).
  lo_col ?= lo_cols->get_column( 'ICON' ).
  lo_col->set_icon( abap_true ).

  lo_alv->display.

ENDFORM.
