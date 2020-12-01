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

#define MAX_CHAR 20
#define ATTACK_DECAY_BUFFER_SIZE 16
#define GAIN_BUFFER_SIZE 256
#define ATTACK_RELEASE_FRAC_BITS 0
#define GAIN_FRAC_BITS 8

static struct class *cl;
static dev_t dev_num;
/* Device struct */
struct fe_ur_ear_fpga_sim_dev {
  struct cdev cdev;
  void __iomem *regs;
  char *name;
  unsigned int Gain;
  unsigned int Attack_and_Decay_Coefficients;
  unsigned int Enable;
};

static int ur_ear_fpga_sim_init(void);
static void ur_ear_fpga_sim_exit(void);
static int ur_ear_fpga_sim_probe(struct platform_device *pdev);
static int ur_ear_fpga_sim_remove(struct platform_device *pdev);
static ssize_t ur_ear_fpga_sim_read(struct file *file, char *buffer, size_t len, loff_t *offset);
static ssize_t ur_ear_fpga_sim_write(struct file *file, const char *buffer, size_t len, loff_t *offset);
static int ur_ear_fpga_sim_open(struct inode *inode, struct file *file);
static int ur_ear_fpga_sim_release(struct inode *inode, struct file *file);

static ssize_t name_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t Gain_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t Gain_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t Attack_and_Decay_Coefficients_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t Attack_and_Decay_Coefficients_read  (struct device *dev, struct device_attribute *attr, char *buf);
static ssize_t Enable_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
static ssize_t Enable_read  (struct device *dev, struct device_attribute *attr, char *buf);
typedef struct fe_ur_ear_fpga_sim_dev fe_ur_ear_fpga_sim_dev_t;
/* ID Matching struct */
static struct of_device_id fe_ur_ear_fpga_sim_dt_ids[] = {
  {
    .compatible = "dev,al-ur_ear_fpga_sim"
  },
  { }
};

/* Platform driver struct */
static struct platform_driver ur_ear_fpga_sim_platform = {
  .probe = ur_ear_fpga_sim_probe,
  .remove = ur_ear_fpga_sim_remove,
  .driver = {
    .name = "Flat Earth ur_ear_fpga_sim Driver",
    .owner = THIS_MODULE,
    .of_match_table = fe_ur_ear_fpga_sim_dt_ids
  }
};

/* File ops struct */
static const struct file_operations fe_ur_ear_fpga_sim_fops = {
  .owner = THIS_MODULE,
  .read = ur_ear_fpga_sim_read,
  .write = ur_ear_fpga_sim_write,
  .open = ur_ear_fpga_sim_open,
  .release = ur_ear_fpga_sim_release,
};


MODULE_LICENSE("GPL");
MODULE_AUTHOR("Autogen <support@flatearthinc.com");
MODULE_DESCRIPTION("Loadable kernel module for the ur_ear_fpga_sim");
MODULE_VERSION("1.0");
MODULE_DEVICE_TABLE(of, fe_ur_ear_fpga_sim_dt_ids);
module_init(ur_ear_fpga_sim_init);
module_exit(ur_ear_fpga_sim_exit);

DEVICE_ATTR(name, 0444, name_read, NULL);
DEVICE_ATTR(Gain, 0664, Gain_read, Gain_write);
DEVICE_ATTR(Attack_and_Decay_Coefficients, 0664, Attack_and_Decay_Coefficients_read, Attack_and_Decay_Coefficients_write);
DEVICE_ATTR(Enable, 0664, Enable_read, Enable_write);
static struct attribute *ur_ear_fpga_sim_attrs[] = {  &dev_attr_name.attr,  &dev_attr_Gain.attr,  &dev_attr_Attack_and_Decay_Coefficients.attr,  &dev_attr_Enable.attr,  NULL};

ATTRIBUTE_GROUPS(ur_ear_fpga_sim);

static int ur_ear_fpga_sim_init(void) {
  int ret_val = 0;
  printk(KERN_ALERT "FUNCTION AUTO GENERATED AT: 2020-12-01 09:16\n");
  pr_info("Initializing the Flat Earth ur_ear_fpga_sim module\n");
  // Register our driver with the "Platform Driver" bus
  ret_val = platform_driver_register(&ur_ear_fpga_sim_platform);  if (ret_val != 0) {
    pr_err("platform_driver_register returned %d\n", ret_val);
    return ret_val;
  }
  pr_info("Flat Earth ur_ear_fpga_sim module successfully initialized!\n");
  return 0;
}
static int ur_ear_fpga_sim_probe(struct platform_device *pdev) {
  int ret_val = -EBUSY;
  char device_name[27] = "fe_ur_ear_fpga_sim_";
  char deviceMinor[20];
  int status;
  struct device *device_obj;
  fe_ur_ear_fpga_sim_dev_t * fe_ur_ear_fpga_sim_devp;
  struct resource *r = NULL;
  pr_info("ur_ear_fpga_sim_probe enter\n");
  fe_ur_ear_fpga_sim_devp = devm_kzalloc(&pdev->dev, sizeof(fe_ur_ear_fpga_sim_dev_t), GFP_KERNEL);
  r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  if (r == NULL) {
    pr_err("IORESOURCE_MEM (register space) does not exist\n");
    goto bad_exit_return;  }
  fe_ur_ear_fpga_sim_devp->regs = devm_ioremap_resource(&pdev->dev, r);
  if (IS_ERR(fe_ur_ear_fpga_sim_devp->regs)) {
    ret_val = PTR_ERR(fe_ur_ear_fpga_sim_devp->regs);
    goto bad_exit_return;
  }
  platform_set_drvdata(pdev, (void *)fe_ur_ear_fpga_sim_devp);
  fe_ur_ear_fpga_sim_devp->name = devm_kzalloc(&pdev->dev, 50, GFP_KERNEL);
  if (fe_ur_ear_fpga_sim_devp->name == NULL)
    goto bad_mem_alloc;
  strcpy(fe_ur_ear_fpga_sim_devp->name, (char *)pdev->name);
  pr_info("%s\n", (char *)pdev->name);
  status = alloc_chrdev_region(&dev_num, 0, 1, "fe_ur_ear_fpga_sim_");
  if (status != 0)
    goto bad_alloc_chrdev_region;
  sprintf(deviceMinor, "%d", MAJOR(dev_num));
  strcat(device_name, deviceMinor);
  pr_info("%s\n", device_name);
  cl = class_create(THIS_MODULE, device_name);
  if (cl == NULL)
    goto bad_class_create;
  cdev_init(&fe_ur_ear_fpga_sim_devp->cdev, &fe_ur_ear_fpga_sim_fops);
  status = cdev_add(&fe_ur_ear_fpga_sim_devp->cdev, dev_num, 1);
  if (status != 0)
    goto bad_cdev_add;
 device_obj = device_create_with_groups(cl, NULL, dev_num, NULL, ur_ear_fpga_sim_groups, device_name);
  if (device_obj == NULL)
    goto bad_device_create;
  dev_set_drvdata(device_obj, fe_ur_ear_fpga_sim_devp);
  pr_info("ur_ear_fpga_sim exit\n");
  return 0;
bad_device_create:
bad_cdev_add:
  cdev_del(&fe_ur_ear_fpga_sim_devp->cdev);
bad_class_create:
  class_destroy(cl);
bad_alloc_chrdev_region:
  unregister_chrdev_region(dev_num, 1);
bad_mem_alloc:
bad_exit_return:
  pr_info("ur_ear_fpga_sim_probe bad exit\n");
  return ret_val;
}


static int ur_ear_fpga_sim_open(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static int ur_ear_fpga_sim_release(struct inode *inode, struct file *file) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t ur_ear_fpga_sim_read(struct file *file, char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}

static ssize_t ur_ear_fpga_sim_write(struct file *file, const char *buffer, size_t len, loff_t *offset) {
  // TODO: fill this in (if its needed, it might not be)
  return 0;
}
static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_ur_ear_fpga_sim_dev_t * devp = (fe_ur_ear_fpga_sim_dev_t *)dev_get_drvdata(dev);
  sprintf(buf, "%s\n", devp->name);
  return strlen(buf);
}

static ssize_t Gain_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_ur_ear_fpga_sim_dev_t * devp = (fe_ur_ear_fpga_sim_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->Gain, 16, false, 16);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t Gain_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  int i,c;
	uint32_t num = 0;
  uint32_t last_num = 0;
  char substring[MAX_CHAR];
  int substring_count = 0;
  int num_counter = 0;
  
  fe_dpr_interface_dev_t *devp = (fe_dpr_interface_dev_t *)dev_get_drvdata(dev);

  // Check to see if the function was called with an empty string
  if (count < 3)
    return count;

  for (i = 0; i < count; i++)
  {
    //If its not a space or a comma, add the digit to the substring
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n'))
    {
      if (num_counter < GAIN_BUFFER_SIZE) 
      {
        substring[substring_count] = buf[i];
        substring_count++;
      }
      else  
      {
        printk(KERN_WARNING "The input exceeded the buffer size.  Only the first %d entries were passed.\n",GAIN_BUFFER_SIZE);
        return count;
      }
    }
    else 
    {
      substring[substring_count] = '\0';
      num = set_fixed_num(substring,GAIN_FRAC_BITS,false);
      iowrite32((num & 0x0000FFFF) + (((uint32_t)num_counter)<<16), (u32 *)devp->regs + 0);
      last_num = num;
      
      for (c = 0; c <= substring_count; c++)
        substring[c] = '\0';
      substring_count = 0;
      num_counter += 1;
    }
  } 
  printk("N:%d\n",num_counter);
  if (num_counter < GAIN_BUFFER_SIZE - 1)
  {
    printk(KERN_WARNING "The buffer was not filled.  Writing last value to the remaining addresses.\n");
    
    for (i = num_counter; i < GAIN_BUFFER_SIZE; i++)
      iowrite32((last_num & 0x0000FFFF) + (((uint32_t)i)<<16), (u32 *)devp->regs + 0);
  }
	return count;
}

static ssize_t Attack_and_Decay_Coefficients_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_ur_ear_fpga_sim_dev_t * devp = (fe_ur_ear_fpga_sim_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->Attack_and_Decay_Coefficients, 16, false, 16);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t Attack_and_Decay_Coefficients_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {

  int i,c;
	uint32_t num = 0;
  uint32_t last_num = 0;
  char substring[MAX_CHAR];
  int substring_count = 0;
  int num_counter = 0;
  
  fe_dpr_interface_dev_t *devp = (fe_dpr_interface_dev_t *)dev_get_drvdata(dev);

  // Check to see if the function was called with an empty string
  if (count < 3)
    return count;

  for (i = 0; i < count; i++)
  {
    //If its not a space or a comma, add the digit to the substring
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n'))
    {
      if (num_counter < ATTACK_DECAY_BUFFER_SIZE) 
      {
        substring[substring_count] = buf[i];
        substring_count++;
      }
      else  
      {
        printk(KERN_WARNING "The input exceeded the buffer size.  Only the first %d entries were passed.\n",ATTACK_DECAY_BUFFER_SIZE);
        return count;
      }
    }
    else 
    {
      substring[substring_count] = '\0';
      num = set_fixed_num(substring,ATTACK_RELEASE_FRAC_BITS,false);
      iowrite32((num & 0x0000FFFF) + (((uint32_t)num_counter)<<16), (u32 *)devp->regs + 1);
      last_num = num;
      
      for (c = 0; c <= substring_count; c++)
        substring[c] = '\0';
      substring_count = 0;
      num_counter += 1;
    }
  } 
  printk("N:%d\n",num_counter);
  if (num_counter < ATTACK_DECAY_BUFFER_SIZE - 1)
  {
    printk(KERN_WARNING "The buffer was not filled.  Writing last value to the remaining addresses.\n");
    
    for (i = num_counter; i < ATTACK_DECAY_BUFFER_SIZE; i++)
      iowrite32((last_num & 0x0000FFFF) + (((uint32_t)i)<<16), (u32 *)devp->regs + 1);
  }
	return count;
}

static ssize_t Enable_read(struct device *dev, struct device_attribute *attr, char *buf) {
  fe_ur_ear_fpga_sim_dev_t * devp = (fe_ur_ear_fpga_sim_dev_t *)dev_get_drvdata(dev);
  fp_to_string(buf, devp->Enable, 0, false, 1);
  strcat2(buf,"\n");
  return strlen(buf);
}

static ssize_t Enable_write(struct device *dev, struct device_attribute *attr, const char *buf, size_t count) {
  uint32_t tempValue = 0;
  char substring[80];
  int substring_count = 0;
  int i;
  fe_ur_ear_fpga_sim_dev_t *devp = (fe_ur_ear_fpga_sim_dev_t *)dev_get_drvdata(dev);
  for (i = 0; i < count; i++) {
    if ((buf[i] != ',') && (buf[i] != ' ') && (buf[i] != '\0') && (buf[i] != '\r') && (buf[i] != '\n')) {
      substring[substring_count] = buf[i];
      substring_count ++;
    }
  }
  substring[substring_count] = 0;
  tempValue = set_fixed_num(substring, 0, false);
  devp->Enable = tempValue;
  iowrite32(devp->Enable, (u32 *)devp->regs + 2);
  return count;
}

static int ur_ear_fpga_sim_remove(struct platform_device *pdev) {
  fe_ur_ear_fpga_sim_dev_t *dev = (fe_ur_ear_fpga_sim_dev_t *)platform_get_drvdata(pdev);
  pr_info("ur_ear_fpga_sim_remove enter\n");
  device_destroy(cl, dev_num);
  cdev_del(&dev->cdev);
  class_destroy(cl);
  unregister_chrdev_region(dev_num, 2);
  pr_info("ur_ear_fpga_sim_remove exit\n");
  return 0;
}


static void ur_ear_fpga_sim_exit(void) {
  pr_info("Flat Earth ur_ear_fpga_sim module exit\n");
  platform_driver_unregister(&ur_ear_fpga_sim_platform);
  pr_info("Flat Earth ur_ear_fpga_sim module successfully unregistered\n");
}
