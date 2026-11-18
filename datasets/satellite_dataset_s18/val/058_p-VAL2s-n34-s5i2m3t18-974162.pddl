(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	satellite4 - satellite
	instrument6 - instrument
	infrared2 - mode
	thermograph0 - mode
	spectrograph1 - mode
	Star4 - direction
	Star7 - direction
	Star8 - direction
	Star13 - direction
	Star3 - direction
	GroundStation9 - direction
	Star14 - direction
	Star0 - direction
	Star16 - direction
	Star12 - direction
	GroundStation2 - direction
	GroundStation11 - direction
	GroundStation5 - direction
	GroundStation17 - direction
	Star1 - direction
	Star10 - direction
	Star6 - direction
	Star15 - direction
	Phenomenon18 - direction
)
(:init
	(supports instrument0 thermograph0)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation17)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 Star14)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon18)
	(supports instrument3 infrared2)
	(supports instrument3 spectrograph1)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 Star15)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 Star12)
	(calibration_target instrument3 Star14)
	(supports instrument4 thermograph0)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 Star14)
	(calibration_target instrument4 Star10)
	(calibration_target instrument4 Star12)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star12)
	(supports instrument5 spectrograph1)
	(calibration_target instrument5 GroundStation11)
	(calibration_target instrument5 GroundStation2)
	(calibration_target instrument5 GroundStation5)
	(calibration_target instrument5 Star12)
	(calibration_target instrument5 Star16)
	(calibration_target instrument5 GroundStation17)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation9)
	(supports instrument6 thermograph0)
	(supports instrument6 infrared2)
	(calibration_target instrument6 Star15)
	(calibration_target instrument6 Star6)
	(calibration_target instrument6 Star10)
	(calibration_target instrument6 Star1)
	(calibration_target instrument6 GroundStation17)
	(calibration_target instrument6 GroundStation5)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star15)
)
(:goal (and
	(pointing satellite4 Star13)
	(have_image Phenomenon18 thermograph0)
))

)
