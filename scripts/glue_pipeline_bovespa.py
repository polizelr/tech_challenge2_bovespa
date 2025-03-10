import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsgluedq.transforms import EvaluateDataQuality
from awsglue.dynamicframe import DynamicFrame
from awsglue import DynamicFrame
from pyspark.sql import functions as SqlFuncs

def sparkSqlQuery(glueContext, query, mapping, transformation_ctx) -> DynamicFrame:
    for alias, frame in mapping.items():
        frame.toDF().createOrReplaceTempView(alias)
    result = spark.sql(query)
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)
def sparkAggregate(glueContext, parentFrame, groups, aggs, transformation_ctx) -> DynamicFrame:
    aggsFuncs = []
    for column, func in aggs:
        aggsFuncs.append(getattr(SqlFuncs, func)(column))
    result = parentFrame.toDF().groupBy(*groups).agg(*aggsFuncs) if len(groups) > 0 else parentFrame.toDF().agg(*aggsFuncs)
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Default ruleset used by all target nodes with data quality enabled
DEFAULT_DATA_QUALITY_RULESET = """
    Rules = [
        ColumnCount > 0
    ]
"""

# Script generated for node Amazon S3
AmazonS3_node1740165403254 = glueContext.create_dynamic_frame.from_options(format_options={}, connection_type="s3", format="parquet", connection_options={"paths": ["s3://fiap-tch2-bovespa/raw-data/"], "recurse": True}, transformation_ctx="AmazonS3_node1740165403254")

# Script generated for node Qtde_float
Qtde_float_node1740173193180 = ApplyMapping.apply(frame=AmazonS3_node1740165403254, mappings=[("Codigo", "string", "Codigo", "string"), ("Acao", "string", "Acao", "string"), ("Tipo", "string", "Tipo", "string"), ("Qtde_Teorica", "string", "Qtde_Teorica", "float"), ("Participacao", "string", "Participacao", "string"), ("Data_Extracao", "string", "Data_Extracao", "date")], transformation_ctx="Qtde_float_node1740173193180")

# Script generated for node Aggregate
Aggregate_node1740228247161 = sparkAggregate(glueContext, parentFrame = Qtde_float_node1740173193180, groups = ["Data_Extracao", "Codigo", "Acao", "Tipo"], aggs = [["Qtde_Teorica", "sum"]], transformation_ctx = "Aggregate_node1740228247161")

# Script generated for node Rename Field
RenameField_node1740229254545 = RenameField.apply(frame=Aggregate_node1740228247161, old_name="`sum(Qtde_Teorica)`", new_name="Quantidade_Total", transformation_ctx="RenameField_node1740229254545")

# Script generated for node Rename Field
RenameField_node1740229680050 = RenameField.apply(frame=RenameField_node1740229254545, old_name="Codigo", new_name="Codigo_Acao", transformation_ctx="RenameField_node1740229680050")

# Script generated for node SQL Query
SqlQuery7229 = '''
SELECT 
    Data_Extracao, 
    Codigo_Acao, 
    Acao, 
    DATEDIFF(
        MAX(CAST(Data_Extracao AS DATE)) OVER (), 
        MIN(CAST(Data_Extracao AS DATE)) OVER ()
    ) AS qtd_dias_amostra,
    Quantidade_Total
FROM myData;
'''
SQLQuery_node1740229742613 = sparkSqlQuery(glueContext, query = SqlQuery7229, mapping = {"myData":RenameField_node1740229680050}, transformation_ctx = "SQLQuery_node1740229742613")

# Script generated for node Amazon S3
EvaluateDataQuality().process_rows(frame=SQLQuery_node1740229742613, ruleset=DEFAULT_DATA_QUALITY_RULESET, publishing_options={"dataQualityEvaluationContext": "EvaluateDataQuality_node1740165315009", "enableDataQualityResultsPublishing": True}, additional_options={"dataQualityResultsPublishing.strategy": "BEST_EFFORT", "observations.scope": "ALL"})
AmazonS3_node1740170915098 = glueContext.getSink(path="s3://fiap-tch2-bovespa/refined/", connection_type="s3", updateBehavior="UPDATE_IN_DATABASE", partitionKeys=["Data_Extracao", "Codigo_Acao"], enableUpdateCatalog=True, transformation_ctx="AmazonS3_node1740170915098")
AmazonS3_node1740170915098.setCatalogInfo(catalogDatabase="database_pipeline_bov",catalogTableName="tb_pipeline_bovespa")
AmazonS3_node1740170915098.setFormat("glueparquet", compression="snappy")
AmazonS3_node1740170915098.writeFrame(SQLQuery_node1740229742613)
job.commit()