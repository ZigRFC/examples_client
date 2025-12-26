How to use https://github.com/ZigRFC/ZigRFC - client example.

### Requirements
Download .lib and .dll files from https://support.sap.com/en/product/connectors/nwrfcsdk.html into folder src/dll/[here]

Create function module on your system:
```abap
FUNCTION zif_rfc_sum
   IMPORTING
     VALUE(X) TYPE I
     VALUE(Y) TYPE I 
   EXPORTING
    VALUE(SUM) TYPE I.
 
  sum = x + y.

END FUNCTION.
```

Fill connection parameters with real data.
