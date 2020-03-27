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
MODULE_DESCRIPTION("Loadable kernel module for the delay_and_sum_beamformer");
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
static int delay_and_sum_beamformer_probe(struct platform_device *pdev);
static int delay_and_sum_beamformer_remove(struct platform_device *pdev);
static ssize_t delay_and_sum_beamformer_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t delay_and_sum_beamformer_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
static int delay_and_sum_beamformer_open(struct inode *inode, struct file *file);
static int delay_and_sum_beamformer_release(struct inode *inode, struct file *file);
static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf);

/************** Generate device specific prototypes ********************/
// FPGA device funcs
static ssize_t azimuth_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t azimuth_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t elevation_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t elevation_read  (struct device *dev, struct device_attribute *attr, char *buf);

/* Custom function declarations */
/* End CreateFunctionPrototypes */


/*************************************************
Generated in WriteDeviceAttributes
*************************************************/
DEVICE_ATTR(azimuth, 0664, azimuth_read, azimuth_write);
DEVICE_ATTR(elevation, 0664, elevation_read, elevation_write);
DEVICE_ATTR(name, 0444, name_read, NULL);
/* End WriteDeviceAttributes */


/****************************************************
Generated in CreateDriverStuff
****************************************************/

/* Device struct */
struct fe_delay_and_sum_beamformer_dev {
  struct cdev cdev;
  char *name;
  void __iomem *regs;
  int azimuth;
  int elevation;
};

typedef struct fe_delay_and_sum_beamformer_dev fe_delay_and_sum_beamformer_dev_t;
/* ID Matching struct */
static struct of_device_id fe_delay_and_sum_beamformer_dt_ids[] = {
  {
    .compatible = "dev,fe-delay_and_sum_beamformer"
  },
  { }
};

MODULE_DEVICE_TABLE(of, fe_delay_and_sum_beamformer_dt_ids);
/* Platform driver struct */
static struct platform_driver delay_and_sum_beamformer_platform = {
  .probe = delay_and_sum_beamformer_probe,
  .remove = delay_and_sum_beamformer_remove,
  .driver = {
    .name = "Flat Earth delay_and_sum_beamformer Driver",
    .owner = THIS_MODULE,
    .of_match_table = fe_delay_and_sum_beamformer_dt_ids
  }
};

/* File ops struct */
static const struct file_operations fe_delay_and_sum_beamformer_fops = {
  .owner = THIS_MODULE,
  .read = delay_and_sum_beamformer_read,
  .write = delay_and_sum_beamformer_write,
  .open = delay_and_sum_beamformer_open,
  .release = delay_and_sum_beamformer_release,
};

/* End of CreateDriverStuff */


/*********************************************************
Generated in CreateInitFunction
*********************************************************/
static int delay_and_sum_beamformer_init(void) {
  int ret_val = 0;
  printk(KERN_ALERT "FUNCTION AUTO GENERATED AT: 2020-03-26 12:52\n");
  pr_info("Initializing the Flat Earth delay_and_sum_beamformer module\n");
  // Register our driver with the "Platform Driver" bus
  ret_val = platform_driver_register(&delay_and_sum_beamformer_platform);  if (ret_val != 0) {
    pr_err("platform_driver_register returned %d\n", ret_val);
    return ret_val;
  }
  pr_info("Flat Earth delay_and_sum_beamformer module successfully initialized!\n");
  return 0;
}
/* End CreateInitFunction */

/************************************************
Generated by CreateProbeFunction
************************************************/
static int delay_and_sum_beamformer_probe(struct platform_device *pdev) {
  int ret_val = -EBUSY;
  char deviceName[36] = "fe_delay_and_sum_beamformer_";
  char deviceMinor[20];
  int status;
  struct device *device_obj;
  fe_delay_and_sum_beamformer_dev_t * fe_delay_and_sum_beamformer_devp;
  struct resource *r = NULL;
  pr_info("delay_and_sum_beamformer_probe enter\n");
  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (r == NULL) {
    pr_err("IORESOURCE_MEM (register space) does not exist\n");
    goto bad_exit_return;  }
  fe_delay_and_sum_beamformer_devp = devm_kzalloc(&pdev->dev, sizeof(fe_delay_and_sum_beamformer_dev_t), GFP_KERNEL);
  fe_delay_and_sum_beamformer_devp->regs = devm_ioremap_resource(&pdev->dev, r);
  if (IS_ERR(fe_delay_and_sum_beamformer_devp->regs))
    goto bad_ioremap;
  platform_set_drvdata(pdev, (void *)fe_delay_and_sum_beamformer_devp);
  fe_delay_and_sum_beamformer_devp->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);
  if (fe_delay_and_sum_beamformer_devp->name == NULL)
    goto bad_mem_alloc;
  strcpy(fe_delay_and_sum_beamformer_devp->name, (char *)pdev->name);
  pr_info("%s\n", (char *)pdev->name);
  status = alloc_chrdev_region(&dev_num, 0, 1, "fe_delay_and_sum_beamformer_");
  if (status != 0)
    goto bad_alloc_chrdev_region;
  sprintf(deviceMinor, "%d", MAJOR(dev_num));
  strcat(deviceName, deviceMinor);
  pr_info("%s\n", deviceName);
  cl = class_create(THIS_MODULE, deviceName);
  if (cl == NULL)
    goto bad_class_create;
  cdev_init(&fe_delay_and_sum_beamformer_devp->cdev, &fe_delay_and_sum_beamformer_fops);
  status = cdev_add(&fe_delay_and_sum_beamformer_devp->cdev, dev_num, 1);
  if (status != 0)
    goto bad_cdev_add;
  device_obj = device_create(cl, NULL, dev_num, NULL, deviceName);
  if (device_obj == NULL)
    goto bad_device_create;
  dev_set_drvdata(device_obj, fe_delay_and_sum_beamformer_devp);
/* Beginning attribute file stuff */
  status = device_create_file(device_obj, &dev_attr_azimuth);
  if (status)
    goto bad_device_create_file_0;

  status = device_create_file(device_obj, &dev_attr_elevation);
  if (status)
    goto bad_device_create_file_1;

  status = device_create_file(device_obj, &dev_attr_name);
  if (status)
    goto bad_device_create_file_3;
  pr_info("HA_probe exit\n");
  return 0;
bad_device_create_file_3:
  device_remove_file(device_obj, &dev_attr_name);
bad_device_create_file_1:
  device_remove_file(device_obj, &dev_attr_elevation);

bad_device_create_file_0:
  device_remove_file(device_obj, &dev_attr_azimuth);

bad_device_create:
  device_destroy(cl, dev_num);

  cdev_del(&fe_delay_and_sum_beamformer_devp->cdev);
bad_cdev_add:
  class_destroy(cl);
bad_class_create:
  unregister_chrdev_region(dev_num, 1);
bad_alloc_chrdev_region:
bad_mem_alloc:
bad_ioremap:
  ret_val = PTR_ERR(fe_delay_and_sum_beamformer_devp->regs);
bad_exit_return:
  pr_info("delay_and_sum_beamformer_probe bad exit\n");
  return ret_val;
}
/* End of CreateProbeFunction */


/*****************************************************
Generated by CreateAttrReadWriteFuncs
****************************************************/
// FPGA Attribute functions
static ssize_t azimuth_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_delay_and_sum_beamformer_dev_t * devp = (fe_delay_and_sum_beamformer_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->azimuth, 16, true, 8);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t azimuth_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_delay_and_sum_beamformer_dev_t *devp = (fe_delay_and_sum_beamformer_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 16, true);
  devp->azimuth = tempValue;
  iowrite32(devp->azimuth, (u32 *)devp->regs + 0);
  return count;
}

static ssize_t elevation_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_delay_and_sum_beamformer_dev_t * devp = (fe_delay_and_sum_beamformer_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->elevation, 16, true, 8);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t elevation_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_delay_and_sum_beamformer_dev_t *devp = (fe_delay_and_sum_beamformer_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 16, true);
  devp->elevation = tempValue;
  iowrite32(devp->elevation, (u32 *)devp->regs + 1);
  return count;
}

static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_delay_and_sum_beamformer_dev_t *devp = (fe_delay_and_sum_beamformer_dev_t *)dev_get_drvdata(dev);
  sprintf(buf, "%s\n", devp->name);
  return strlen(buf);
}
/* End of CreateAttrReadWriteFuncs */


/*****************************************
  Generated by CreateCFunctionStubs
*****************************************/
static int delay_and_sum_beamformer_open(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static int delay_and_sum_beamformer_release(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t delay_and_sum_beamformer_read(struct file *file, char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t delay_and_sum_beamformer_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}
 /* End CreateCFunctionStubs */


/******************************************************
Generated in CreateRemoveFunction
*******************************************************/
static int delay_and_sum_beamformer_remove(struct platform_device *pdev) {
  fe_delay_and_sum_beamformer_dev_t *dev = (fe_delay_and_sum_beamformer_dev_t *)platform_get_drvdata(pdev);
  pr_info("delay_and_sum_beamformer_remove enter\n");
  cdev_del(&dev->cdev);
  unregister_chrdev_region(dev_num, 2);
  iounmap(dev->regs);
  pr_info("delay_and_sum_beamformer_remove exit\n");
  return 0;
}
/* End CreateRemoveFunction */


/***********************************************
Generated by CreateExitFunction
************************************************/
static void delay_and_sum_beamformer_exit(void) {
  pr_info("Flat Earth delay_and_sum_beamformer module exit\n");
  platform_driver_unregister(&delay_and_sum_beamformer_platform);
  pr_info("Flat Earth delay_and_sum_beamformer module successfully unregistered\n");
}
/* End CreateExitFunction */


/*********************************************
Generated by CreateCustomFunctions
**********************************************/
/* End CreateCustomFunctions */


/********************************************
Generated by CreateEndOfFileStuff
********************************************/
module_init(delay_and_sum_beamformer_init);
module_exit(delay_and_sum_beamformer_exit);
/* End CreateEndOfFileStuff */
