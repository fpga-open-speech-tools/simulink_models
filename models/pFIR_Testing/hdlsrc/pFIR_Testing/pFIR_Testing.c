/*********************************************************************
Generated in CreateFileHeaderInfo 
*********************************************************************/
#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/io.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/init.h>
#include <linux/cdev.h>
#include <linux/regmap.h>
#include <linux/of.h>
#include "custom_functions.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Tyler Davis <support@flatearthinc.com");
MODULE_DESCRIPTION("Loadable kernel module for the pFIR_Testing");
MODULE_VERSION("1.0");
/* End CreateFileHeaderInfo */


/***********************************************
  Generated in CreateMiscTopOfFile
***********************************************/
struct fixed_num {
  int integer;
  int fraction;
  int fraction_len;
};
static struct class *cl;  // Global variable for the device class
static dev_t dev_num;

/*********** Device type specific things **************/
//TODO: check this. Register memory map. Was not pulled from input params, might want to verify this
#define BAND_ALL_OFFSET 0x00
#define BAND1_OFFSET 0x01
#define BAND2_OFFSET 0x02
#define BAND3_OFFSET 0x03
#define BAND4_OFFSET 0x04
#define LEFT_OFFSET 0x00
#define RIGHT_OFFSET 0x08
#define GAIN_OFFSET 0
/* End of CreateMiscTopOfFile */


/*****************************************************
Generate in CreateFunctionPrototypes
*****************************************************/
static int pFIR_Testing_probe(struct platform_device *pdev);
static int pFIR_Testing_remove(struct platform_device *pdev);
static ssize_t pFIR_Testing_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t pFIR_Testing_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
static int pFIR_Testing_open(struct inode *inode, struct file *file);
static int pFIR_Testing_release(struct inode *inode, struct file *file);
static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf);

/************** Generate device specific prototypes ********************/
// FPGA device funcs
static ssize_t enable_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t enable_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t Wr_Data_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t Wr_Data_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t RW_Addr_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t RW_Addr_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t Wr_En_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t Wr_En_read  (struct device *dev, struct device_attribute *attr, char *buf);

/* Custom function declarations */
/* End CreateFunctionPrototypes */


/*************************************************
Generated in WriteDeviceAttributes
*************************************************/
DEVICE_ATTR(enable, 0664, enable_read, enable_write);
DEVICE_ATTR(Wr_Data, 0664, Wr_Data_read, Wr_Data_write);
DEVICE_ATTR(RW_Addr, 0664, RW_Addr_read, RW_Addr_write);
DEVICE_ATTR(Wr_En, 0664, Wr_En_read, Wr_En_write);
DEVICE_ATTR(name, 0444, name_read, NULL);
/* End WriteDeviceAttributes */


/****************************************************
Generated in CreateDriverStuff
****************************************************/

/* Device struct */
struct fe_pFIR_Testing_dev {
  struct cdev cdev;
  char *name;
  void __iomem *regs;
  int enable;
  int Wr_Data;
  int RW_Addr;
  int Wr_En;
};

typedef struct fe_pFIR_Testing_dev fe_pFIR_Testing_dev_t;
/* ID Matching struct */
static struct of_device_id fe_pFIR_Testing_dt_ids[] = {
  {
    .compatible = "dev,fe-pFIR_Testing"
  },
  { }
};

MODULE_DEVICE_TABLE(of, fe_pFIR_Testing_dt_ids);
/* Platform driver struct */
static struct platform_driver pFIR_Testing_platform = {
  .probe = pFIR_Testing_probe,
  .remove = pFIR_Testing_remove,
  .driver = {
    .name = "Flat Earth pFIR_Testing Driver",
    .owner = THIS_MODULE,
    .of_match_table = fe_pFIR_Testing_dt_ids
  }
};

/* File ops struct */
static const struct file_operations fe_pFIR_Testing_fops = {
  .owner = THIS_MODULE,
  .read = pFIR_Testing_read,
  .write = pFIR_Testing_write,
  .open = pFIR_Testing_open,
  .release = pFIR_Testing_release,
};

/* End of CreateDriverStuff */


/*********************************************************
Generated in CreateInitFunction
*********************************************************/
static int pFIR_Testing_init(void) {
  int ret_val = 0;
  printk(KERN_ALERT "FUNCTION AUTO GENERATED AT: 2020-03-09 21:41\n");
  pr_info("Initializing the Flat Earth pFIR_Testing module\n");
  // Register our driver with the "Platform Driver" bus
  ret_val = platform_driver_register(&pFIR_Testing_platform);  if (ret_val != 0) {
    pr_err("platform_driver_register returned %d\n", ret_val);
    return ret_val;
  }
  pr_info("Flat Earth pFIR_Testing module successfully initialized!\n");
  return 0;
}
/* End CreateInitFunction */

/************************************************
Generated by CreateProbeFunction
************************************************/
static int pFIR_Testing_probe(struct platform_device *pdev) {
  int ret_val = -EBUSY;
  char deviceName[24] = "fe_pFIR_Testing_";
  char deviceMinor[20];
  int status;
  struct device *device_obj;
  fe_pFIR_Testing_dev_t * fe_pFIR_Testing_devp;
  struct resource *r = NULL;
  pr_info("pFIR_Testing_probe enter\n");
  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (r == NULL) {
    pr_err("IORESOURCE_MEM (register space) does not exist\n");
    goto bad_exit_return;  }
  fe_pFIR_Testing_devp = devm_kzalloc(&pdev->dev, sizeof(fe_pFIR_Testing_dev_t), GFP_KERNEL);
  fe_pFIR_Testing_devp->regs = devm_ioremap_resource(&pdev->dev, r);
  if (IS_ERR(fe_pFIR_Testing_devp->regs))
    goto bad_ioremap;
  platform_set_drvdata(pdev, (void *)fe_pFIR_Testing_devp);
  fe_pFIR_Testing_devp->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);
  if (fe_pFIR_Testing_devp->name == NULL)
    goto bad_mem_alloc;
  strcpy(fe_pFIR_Testing_devp->name, (char *)pdev->name);
  pr_info("%s\n", (char *)pdev->name);
  status = alloc_chrdev_region(&dev_num, 0, 1, "fe_pFIR_Testing_");
  if (status != 0)
    goto bad_alloc_chrdev_region;
  sprintf(deviceMinor, "%d", MAJOR(dev_num));
  strcat(deviceName, deviceMinor);
  pr_info("%s\n", deviceName);
  cl = class_create(THIS_MODULE, deviceName);
  if (cl == NULL)
    goto bad_class_create;
  cdev_init(&fe_pFIR_Testing_devp->cdev, &fe_pFIR_Testing_fops);
  status = cdev_add(&fe_pFIR_Testing_devp->cdev, dev_num, 1);
  if (status != 0)
    goto bad_cdev_add;
  device_obj = device_create(cl, NULL, dev_num, NULL, deviceName);
  if (device_obj == NULL)
    goto bad_device_create;
  dev_set_drvdata(device_obj, fe_pFIR_Testing_devp);
/* Beginning attribute file stuff */
  status = device_create_file(device_obj, &dev_attr_enable);
  if (status)
    goto bad_device_create_file_0;

  status = device_create_file(device_obj, &dev_attr_Wr_Data);
  if (status)
    goto bad_device_create_file_1;

  status = device_create_file(device_obj, &dev_attr_RW_Addr);
  if (status)
    goto bad_device_create_file_2;

  status = device_create_file(device_obj, &dev_attr_Wr_En);
  if (status)
    goto bad_device_create_file_3;

  status = device_create_file(device_obj, &dev_attr_name);
  if (status)
    goto bad_device_create_file_5;
  pr_info("HA_probe exit\n");
  return 0;
bad_device_create_file_5:
  device_remove_file(device_obj, &dev_attr_name);
bad_device_create_file_3:
  device_remove_file(device_obj, &dev_attr_Wr_En);

bad_device_create_file_2:
  device_remove_file(device_obj, &dev_attr_RW_Addr);

bad_device_create_file_1:
  device_remove_file(device_obj, &dev_attr_Wr_Data);

bad_device_create_file_0:
  device_remove_file(device_obj, &dev_attr_enable);

bad_device_create:
  device_destroy(cl, dev_num);

  cdev_del(&fe_pFIR_Testing_devp->cdev);
bad_cdev_add:
  class_destroy(cl);
bad_class_create:
  unregister_chrdev_region(dev_num, 1);
bad_alloc_chrdev_region:
bad_mem_alloc:
bad_ioremap:
  ret_val = PTR_ERR(fe_pFIR_Testing_devp->regs);
bad_exit_return:
  pr_info("pFIR_Testing_probe bad exit\n");
  return ret_val;
}
/* End of CreateProbeFunction */


/*****************************************************
Generated by CreateAttrReadWriteFuncs
****************************************************/
// FPGA Attribute functions
static ssize_t enable_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_pFIR_Testing_dev_t * devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->enable, 32, true, 28);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t enable_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_pFIR_Testing_dev_t *devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 32, true);
  devp->enable = tempValue;
  iowrite32(devp->enable, (u32 *)devp->regs + 0);
  return count;
}

static ssize_t Wr_Data_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_pFIR_Testing_dev_t * devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->Wr_Data, 32, true, 28);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t Wr_Data_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_pFIR_Testing_dev_t *devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 32, true);
  devp->Wr_Data = tempValue;
  iowrite32(devp->Wr_Data, (u32 *)devp->regs + 1);
  return count;
}

static ssize_t RW_Addr_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_pFIR_Testing_dev_t * devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->RW_Addr, 32, false, 0);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t RW_Addr_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_pFIR_Testing_dev_t *devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 32, false);
  devp->RW_Addr = tempValue;
  iowrite32(devp->RW_Addr, (u32 *)devp->regs + 2);
  return count;
}

static ssize_t Wr_En_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_pFIR_Testing_dev_t * devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->Wr_En, 32, true, 0);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t Wr_En_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_pFIR_Testing_dev_t *devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 32, true);
  devp->Wr_En = tempValue;
  iowrite32(devp->Wr_En, (u32 *)devp->regs + 3);
  return count;
}

static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_pFIR_Testing_dev_t *devp = (fe_pFIR_Testing_dev_t *)dev_get_drvdata(dev);
  sprintf(buf, "%s\n", devp->name);
  return strlen(buf);
}
/* End of CreateAttrReadWriteFuncs */


/*****************************************
  Generated by CreateCFunctionStubs
*****************************************/
static int pFIR_Testing_open(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static int pFIR_Testing_release(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t pFIR_Testing_read(struct file *file, char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t pFIR_Testing_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}
 /* End CreateCFunctionStubs */


/******************************************************
Generated in CreateRemoveFunction
*******************************************************/
static int pFIR_Testing_remove(struct platform_device *pdev) {
  fe_pFIR_Testing_dev_t *dev = (fe_pFIR_Testing_dev_t *)platform_get_drvdata(pdev);
  pr_info("pFIR_Testing_remove enter\n");
  cdev_del(&dev->cdev);
  unregister_chrdev_region(dev_num, 2);
  iounmap(dev->regs);
  pr_info("pFIR_Testing_remove exit\n");
  return 0;
}
/* End CreateRemoveFunction */


/***********************************************
Generated by CreateExitFunction
************************************************/
static void pFIR_Testing_exit(void) {
  pr_info("Flat Earth pFIR_Testing module exit\n");
  platform_driver_unregister(&pFIR_Testing_platform);
  pr_info("Flat Earth pFIR_Testing module successfully unregistered\n");
}
/* End CreateExitFunction */


/*********************************************
Generated by CreateCustomFunctions
**********************************************/
/* End CreateCustomFunctions */


/********************************************
Generated by CreateEndOfFileStuff
********************************************/
module_init(pFIR_Testing_init);
module_exit(pFIR_Testing_exit);
/* End CreateEndOfFileStuff */
